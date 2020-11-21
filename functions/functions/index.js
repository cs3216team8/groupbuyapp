const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.sendNotification = functions.firestore
    .document("chatRooms/{chatRoomId}/messages/{messageId}")
    .onCreate(async snapshot => {
        const message = snapshot.data();
        const querySnapshot = await db
            .collection('users')
            .doc('7RqTgkmFo9g1KbKdqdahCR6S2Th1')
            .collection('tokens')
            .get();
        const tokens = querySnapshot.docs.map(snap => snap.id);
        const payload = {
            notification: {
                title: 'New Message',
                body: 'you got a message',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data: {
                view: 'chat',
                chatRoomId: 'ezDEidkJFbbLZN2TFI2fgJx8H9r1_7RqTgkmFo9g1KbKdqdahCR6S2Th1',
                username: 'username',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
