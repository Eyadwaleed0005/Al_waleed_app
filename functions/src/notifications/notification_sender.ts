import {getMessaging} from "firebase-admin/messaging";

import {GradeNotification} from "./notification_type";

const gradeTopicPrefix = "grade_";

export async function sendGradeNotification(
  notification: GradeNotification,
): Promise<void> {
  const eventId = normalizeRequiredValue(
    notification.eventId,
  );

  const gradeId = normalizeRequiredValue(
    notification.gradeId,
  );

  const resourceId = normalizeRequiredValue(
    notification.resourceId,
  );

  const topic = createGradeTopic(gradeId);

  await getMessaging().send({
    topic,
    data: {
      eventId,
      type: notification.type,
      resourceId,
      gradeId,
      title: notification.title,
      body: notification.body,
    },
    android: {
      priority: "high",
    },
    apns: {
      headers: {
        "apns-collapse-id": eventId,
        "apns-push-type": "alert",
        "apns-priority": "10",
      },
      payload: {
        aps: {
          alert: {
            title: notification.title,
            body: notification.body,
          },
          sound: "default",
        },
      },
    },
  });
}

function createGradeTopic(
  gradeId: string,
): string {
  const validTopicValue = /^[a-zA-Z0-9_.~%-]+$/;

  if (!validTopicValue.test(gradeId)) {
    throw new Error(
      "Invalid grade topic value.",
    );
  }

  return `${gradeTopicPrefix}${gradeId}`;
}

function normalizeRequiredValue(
  value: string,
): string {
  const normalizedValue = value.trim();

  if (normalizedValue.length === 0) {
    throw new Error(
      "Required notification value is missing.",
    );
  }

  return normalizedValue;
}
