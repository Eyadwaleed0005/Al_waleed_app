import {initializeApp} from "firebase-admin/app";
import {setGlobalOptions} from "firebase-functions/v2";

initializeApp();

setGlobalOptions({
  region: "us-central1",
  maxInstances: 10,
});

export {
  notifyStudentsWhenExamPublished,
  notifyStudentsWhenLessonPublished,
  notifyStudentsWhenLiveSessionCreated,
  notifyStudentsWhenStudyNotePublished,
} from "./notifications/firestore_notification_triggers";
