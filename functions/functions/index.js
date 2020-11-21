const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.sendNotification = functions.firestore
    .document("chatRooms/{chatRoomId}/messages/{messageId}")
    .onCreate(async snapshot => {
        const message = snapshot.data();
        const senderUid = message.user.uid;
        const senderName = await db.collection("users").doc(senderUid).get().name;
        const cid = context.params.chatRoomId;
        const receiverUid = cid.replaceAll(senderUid, "").replaceAll("_", "");
        const querySnapshot = await db
            .collection('users')
            .doc(receiverUid)
            .collection('tokens')
            .get();
        const tokens = querySnapshot.docs.map(snap => snap.id);
        const payload = {
            notification: {
                title: 'Chat Message from ' + senderName,
                body: message.text,
            },
            data: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                view: 'chat',
                chatRoomId: 'ezDEidkJFbbLZN2TFI2fgJx8H9r1_7RqTgkmFo9g1KbKdqdahCR6S2Th1',
                username: senderName,
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });


//exports.sendGroupBuyNotification = functions.firestore
//    .document("groupBuys/{groupBuyId}")
//    .onUpdate

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
