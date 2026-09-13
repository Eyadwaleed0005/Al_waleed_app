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

export {
  startExamAttempt,
} from "./exams/start_exam_attempt";

export {
  getStudentExam,
} from "./exams/get_student_exam";

export {
  submitExamAttempt,
} from "./exams/submit_exam_attempt";
