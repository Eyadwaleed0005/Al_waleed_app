export enum AppNotificationType {
  lesson = "lesson",
  studyNote = "studyNote",
  exam = "exam",
  liveSession = "liveSession",
}

export interface GradeNotification {
  eventId: string;
  type: AppNotificationType;
  resourceId: string;
  gradeId: string;
  title: string;
  body: string;
}
