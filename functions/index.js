const admin = require("firebase-admin");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2");

admin.initializeApp();

setGlobalOptions({
  region: "us-central1",
  maxInstances: 10,
});

exports.sendApplicationNotification = onDocumentUpdated(
  "applications/{applicationId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    if (!before || !after) return;

    // Status change na hua ho to kuch mat karo
    if (before.status === after.status) {
      return;
    }

    // Sirf Accepted / Rejected par notification bhejo
    if (
      after.status !== "Accepted" &&
      after.status !== "Rejected"
    ) {
      return;
    }

    try {
      const userDoc = await admin
          .firestore()
          .collection("users")
          .doc(after.userId)
          .get();

      if (!userDoc.exists) {
        console.log("User not found");
        return;
      }

      const user = userDoc.data();

      if (!user.fcmToken) {
        console.log("FCM Token not found");
        return;
      }

      let title = "";
      let body = "";

      if (after.status === "Accepted") {
        title = "🎉 Application Accepted";
        body =
          `Congratulations! Your application for ${after.jobTitle} has been accepted.`;
      } else {
        title = "❌ Application Rejected";
        body =
          `Your application for ${after.jobTitle} has been rejected.`;
      }

      const message = {
        token: user.fcmToken,

        notification: {
          title: title,
          body: body,
        },

        android: {
          priority: "high",
          notification: {
            channelId: "job_portal",
            sound: "default",
          },
        },

        data: {
          status: after.status,
          jobTitle: after.jobTitle,
        },
      };

      await admin.messaging().send(message);

      console.log("Notification Sent");
    } catch (e) {
      console.error(e);
    }
  },
);