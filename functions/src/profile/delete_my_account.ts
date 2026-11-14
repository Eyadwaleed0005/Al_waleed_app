import {getAuth} from "firebase-admin/auth";
import {
  FieldValue,
  getFirestore,
} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";

export const deleteMyAccount = onCall(
  {
    region: "us-central1",
    memory: "256MiB",
    cpu: "gcf_gen1",
    timeoutSeconds: 300,
    minInstances: 0,
    maxInstances: 10,
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "يجب تسجيل الدخول أولًا.",
      );
    }

    const authorization =
            request.rawRequest.headers.authorization;

    const idToken = authorization?.startsWith("Bearer ") ?
      authorization.slice(7) :
      "";

    if (!idToken) {
      throw new HttpsError(
        "unauthenticated",
        "تعذر التحقق من هويتك.",
      );
    }

    const auth = getAuth();

    const token = await auth
      .verifyIdToken(idToken, true)
      .catch(() => {
        throw new HttpsError(
          "unauthenticated",
          "انتهت صلاحية الجلسة. سجّل الدخول مرة أخرى.",
        );
      });

    if (token.uid !== request.auth.uid) {
      throw new HttpsError(
        "permission-denied",
        "غير مسموح بتنفيذ العملية.",
      );
    }

    const now = Math.floor(Date.now() / 1000);
    const authenticationAge = now - token.auth_time;

    if (
      !Number.isFinite(authenticationAge) ||
            authenticationAge < -30 ||
            authenticationAge > 300 ||
            token.firebase.sign_in_provider !== "password"
    ) {
      throw new HttpsError(
        "failed-precondition",
        "أكد كلمة المرور الحالية ثم حاول مرة أخرى.",
        {reason: "requires-recent-login"},
      );
    }

    const studentId = token.uid;
    const firestore = getFirestore();

    const studentReference = firestore
      .collection("students")
      .doc(studentId);

    try {
      await firestore.runTransaction(
        async (transaction) => {
          const studentSnapshot = await transaction.get(
            studentReference,
          );

          if (studentSnapshot.exists) {
            transaction.update(
              studentReference,
              {
                isDeleting: true,
                updatedAt: FieldValue.serverTimestamp(),
              },
            );
          }
        },
      );

      await deleteStudentDocuments(
        "examResults",
        studentId,
      );

      await deleteStudentDocuments(
        "examAttemptAnswers",
        studentId,
      );

      await firestore.recursiveDelete(
        studentReference,
      );

      try {
        await auth.deleteUser(studentId);
      } catch (error) {
        if (getErrorCode(error) !== "auth/user-not-found") {
          throw error;
        }
      }

      return {
        success: true,
      };
    } catch (error) {
      logger.error(
        "Student account deletion failed.",
        {
          studentId,
          errorCode: getErrorCode(error),
        },
      );

      throw new HttpsError(
        "internal",
        "تعذر إكمال حذف الحساب. حاول مرة أخرى.",
      );
    }
  },
);

async function deleteStudentDocuments(
  collectionName: string,
  studentId: string,
): Promise<void> {
  const firestore = getFirestore();
  let hasMoreDocuments = true;

  while (hasMoreDocuments) {
    const snapshot = await firestore
      .collection(collectionName)
      .where("studentId", "==", studentId)
      .limit(200)
      .get();

    if (snapshot.empty) {
      return;
    }

    const batch = firestore.batch();

    for (const document of snapshot.docs) {
      batch.delete(document.ref);
    }

    await batch.commit();

    hasMoreDocuments = snapshot.size === 200;
  }
}

function getErrorCode(error: unknown): string {
  if (
    typeof error === "object" &&
        error !== null &&
        "code" in error
  ) {
    return String(error.code);
  }

  return "";
}
