import {
  onDocumentCreated,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";

import {
  FirestoreCollections,
} from "../core/firestore/firestore_collections";
import {
  FirestoreFields,
} from "../core/firestore/firestore_fields";
import {
  sendGradeNotification,
} from "./notification_sender";
import {
  AppNotificationType,
} from "./notification_type";

export const notifyStudentsWhenLessonPublished =
  onDocumentWritten(
    {
      document:
        `${FirestoreCollections.lessons}/{lessonId}`,
      retry: false,
    },
    async (event): Promise<void> => {
      const beforeData = event.data?.before.data();
      const afterData = event.data?.after.data();

      if (
        afterData == null ||
        !becamePublished(beforeData, afterData)
      ) {
        return;
      }

      const gradeId = readRequiredString(
        afterData,
        FirestoreFields.gradeId,
      );

      const lessonTitle = readRequiredString(
        afterData,
        FirestoreFields.title,
      );

      if (gradeId == null || lessonTitle == null) {
        logger.warn(
          "Lesson notification data is incomplete.",
          {
            eventId: event.id,
            lessonId: event.params.lessonId,
          },
        );

        return;
      }

      const youtubeUrl = readRequiredString(
        afterData,
        "youtubeUrl",
      );

      const imageUrl = createYoutubeThumbnailUrl(
        youtubeUrl,
      );

      await sendGradeNotification({
        eventId: event.id,
        type: AppNotificationType.lesson,
        resourceId: event.params.lessonId,
        gradeId,
        title: "درس جديد",
        body: `تم إضافة درس جديد ${lessonTitle}`,
        imageUrl,
      });
    },
  );

export const notifyStudentsWhenStudyNotePublished =
  onDocumentWritten(
    {
      document:
        `${FirestoreCollections.studyNotes}/{noteId}`,
      retry: false,
    },
    async (event): Promise<void> => {
      const beforeData = event.data?.before.data();
      const afterData = event.data?.after.data();

      if (
        afterData == null ||
        !becamePublished(beforeData, afterData)
      ) {
        return;
      }

      const gradeId = readRequiredString(
        afterData,
        FirestoreFields.gradeId,
      );

      const noteName = readRequiredString(
        afterData,
        FirestoreFields.name,
      );

      if (gradeId == null || noteName == null) {
        logger.warn(
          "Study note notification data is incomplete.",
          {
            eventId: event.id,
            noteId: event.params.noteId,
          },
        );

        return;
      }

      await sendGradeNotification({
        eventId: event.id,
        type: AppNotificationType.studyNote,
        resourceId: event.params.noteId,
        gradeId,
        title: "مذكرة جديدة",
        body: `تم إضافة مذكرة جديدة ${noteName}`,
      });
    },
  );

export const notifyStudentsWhenExamPublished =
  onDocumentWritten(
    {
      document:
        `${FirestoreCollections.exams}/{examId}`,
      retry: false,
    },
    async (event): Promise<void> => {
      const beforeData = event.data?.before.data();
      const afterData = event.data?.after.data();

      if (
        afterData == null ||
        !becamePublishedExam(beforeData, afterData)
      ) {
        return;
      }

      const gradeId = readRequiredString(
        afterData,
        FirestoreFields.gradeId,
      );

      const examName = readRequiredString(
        afterData,
        FirestoreFields.examName,
      );

      if (gradeId == null || examName == null) {
        logger.warn(
          "Exam notification data is incomplete.",
          {
            eventId: event.id,
            examId: event.params.examId,
          },
        );

        return;
      }

      await sendGradeNotification({
        eventId: event.id,
        type: AppNotificationType.exam,
        resourceId: event.params.examId,
        gradeId,
        title: "امتحان جديد",
        body: `تم نشر امتحان جديد ${examName}`,
      });
    },
  );

export const notifyStudentsWhenLiveSessionCreated =
  onDocumentCreated(
    {
      document:
        `${FirestoreCollections.liveSessions}/{liveSessionId}`,
      retry: false,
    },
    async (event): Promise<void> => {
      const sessionData = event.data?.data();

      if (sessionData == null) {
        return;
      }

      const gradeId = readRequiredString(
        sessionData,
        FirestoreFields.gradeId,
      );

      if (gradeId == null) {
        logger.warn(
          "Live session notification data is incomplete.",
          {
            eventId: event.id,
            liveSessionId: event.params.liveSessionId,
          },
        );

        return;
      }

      await sendGradeNotification({
        eventId: event.id,
        type: AppNotificationType.liveSession,
        resourceId: event.params.liveSessionId,
        gradeId,
        title: "بث مباشر جديد",
        body: "تم بدء بث مباشر جديد لصفك.",
      });
    },
  );

function becamePublished(
  beforeData: Record<string, unknown> | undefined,
  afterData: Record<string, unknown>,
): boolean {
  const wasPublished =
    beforeData?.[FirestoreFields.isPublished] === true;

  const isPublished =
    afterData[FirestoreFields.isPublished] === true;

  return !wasPublished && isPublished;
}

function becamePublishedExam(
  beforeData: Record<string, unknown> | undefined,
  afterData: Record<string, unknown>,
): boolean {
  const previousStatus = normalizeString(
    beforeData?.[FirestoreFields.examStatus],
  );

  const currentStatus = normalizeString(
    afterData[FirestoreFields.examStatus],
  );

  return (
    previousStatus !== "published" &&
    currentStatus === "published"
  );
}

function readRequiredString(
  data: Record<string, unknown>,
  field: string,
): string | null {
  return normalizeString(data[field]);
}

function normalizeString(
  value: unknown,
): string | null {
  if (typeof value !== "string") {
    return null;
  }

  const normalizedValue = value.trim();

  return normalizedValue.length > 0 ?
    normalizedValue :
    null;
}

function createYoutubeThumbnailUrl(
  youtubeUrl: string | null,
): string | undefined {
  if (!youtubeUrl) {
    return undefined;
  }

  const value = youtubeUrl.trim();
  const validVideoId = /^[a-zA-Z0-9_-]{11}$/;

  if (validVideoId.test(value)) {
    return `https://img.youtube.com/vi/${value}/hqdefault.jpg`;
  }

  try {
    const url = new URL(value);

    if (
      url.protocol !== "https:" &&
      url.protocol !== "http:"
    ) {
      return undefined;
    }

    const host = url.hostname.toLowerCase();

    const parts = url.pathname
      .split("/")
      .filter(Boolean);

    let videoId: string | null = null;

    if (
      host === "youtu.be" ||
      host === "www.youtu.be"
    ) {
      videoId = parts[0] ?? null;
    } else {
      const isYoutubeHost =
        host === "youtube.com" ||
        host.endsWith(".youtube.com") ||
        host === "youtube-nocookie.com" ||
        host.endsWith(".youtube-nocookie.com");

      if (!isYoutubeHost) {
        return undefined;
      }

      if (parts[0] === "watch") {
        videoId = url.searchParams.get("v");
      } else if (
        parts[0] === "shorts" ||
        parts[0] === "embed" ||
        parts[0] === "live" ||
        parts[0] === "v"
      ) {
        videoId = parts[1] ?? null;
      }
    }

    if (!videoId || !validVideoId.test(videoId)) {
      return undefined;
    }

    return `https://img.youtube.com/vi/${videoId}/hqdefault.jpg`;
  } catch {
    return undefined;
  }
}
