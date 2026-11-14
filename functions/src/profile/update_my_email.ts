import {getAuth} from "firebase-admin/auth";
import {
  FieldValue,
  getFirestore,
} from "firebase-admin/firestore";
import {
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";

export const updateMyEmail = onCall(
  {
    region: "us-central1",
    memory: "256MiB",
    timeoutSeconds: 60,
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

    const rawEmail = request.data?.newEmail;

    if (typeof rawEmail !== "string") {
      throw new HttpsError(
        "invalid-argument",
        "من فضلك اكتب البريد الإلكتروني الجديد.",
      );
    }

    const newEmail = rawEmail.trim().toLowerCase();

    if (
      newEmail.length > 254 ||
            !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newEmail)
    ) {
      throw new HttpsError(
        "invalid-argument",
        "من فضلك اكتب بريدًا إلكترونيًا صحيحًا.",
      );
    }

    const studentDocument = getFirestore()
      .collection("students")
      .doc(token.uid);

    const studentSnapshot = await studentDocument.get();

    if (!studentSnapshot.exists) {
      throw new HttpsError(
        "not-found",
        "لم يتم العثور على بيانات الطالب.",
      );
    }

    let updatedEmail: string;

    try {
      const currentUser = await auth.getUser(token.uid);

      if (currentUser.disabled) {
        throw new HttpsError(
          "permission-denied",
          "هذا الحساب معطّل.",
        );
      }

      const currentEmail =
                currentUser.email?.trim().toLowerCase();

      if (currentEmail === newEmail) {
        updatedEmail = newEmail;
      } else {
        const updatedUser = await auth.updateUser(
          token.uid,
          {
            email: newEmail,
            emailVerified: false,
          },
        );

        updatedEmail = updatedUser.email ?? newEmail;
      }
    } catch (error) {
      if (error instanceof HttpsError) {
        throw error;
      }

      const code = (
                error as { code?: string }
      ).code;

      switch (code) {
      case "auth/email-already-exists":
        throw new HttpsError(
          "already-exists",
          "البريد الإلكتروني مستخدم في حساب آخر.",
        );

      case "auth/invalid-email":
        throw new HttpsError(
          "invalid-argument",
          "البريد الإلكتروني غير صحيح.",
        );

      case "auth/user-not-found":
        throw new HttpsError(
          "not-found",
          "لم يتم العثور على الحساب.",
        );

      default:
        throw new HttpsError(
          "internal",
          "تعذر تعديل البريد الإلكتروني. حاول مرة أخرى.",
        );
      }
    }

    try {
      await studentDocument.update({
        email: updatedEmail,
        updatedAt: FieldValue.serverTimestamp(),
      });
    } catch {
      throw new HttpsError(
        "internal",
        "تم تغيير بريد تسجيل الدخول، لكن تعذر تحديث بيانات الطالب.",
        {
          reason: "profile-sync-failed",
          emailUpdated: true,
          email: updatedEmail,
        },
      );
    }

    return {
      success: true,
      email: updatedEmail,
    };
  },
);
