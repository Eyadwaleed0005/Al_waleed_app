import {getMessaging} from "firebase-admin/messaging";

import {GradeNotification} from "./notification_type";

const gradeTopicPrefix = "grade_";

const androidNotificationChannelId =
  "high_importance_channel_v2";

const androidNotificationSound =
  "al_waleed_notification";

const androidNotificationIcon =
  "ic_notification";

const androidNotificationColor =
  "#023A22";

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
    notification: {
      title: notification.title,
      body: notification.body,
    },
    data: {
      eventId,
      type: notification.type,
      resourceId,
      gradeId,
    },
    android: {
      priority: "high",
      collapseKey: eventId,
      notification: {
        channelId: androidNotificationChannelId,
        icon: androidNotificationIcon,
        color: androidNotificationColor,
        sound: androidNotificationSound,
        tag: eventId,
      },
    },
    apns: {
      headers: {
        "apns-collapse-id": eventId,
      },
      payload: {
        aps: {
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
