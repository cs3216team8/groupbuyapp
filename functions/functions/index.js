const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.sendNotification = functions.firestore
    .document("chatRooms/{chatRoomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
        const message = snapshot.data();
        const senderUid = message.user.uid;
        const senderSnapshot = await db
            .collection("users")
            .doc(senderUid)
            .get();
        const senderName = senderSnapshot.data()['name'];
        const cid = context.params.chatRoomId;
        const receiverUid = cid.toString()
            .replace(senderUid, "")
            .replace("_", "");
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
                chatRoomId: cid,
                username: senderName,
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });

exports.sendRequestNotification = functions.firestore
    .document("groupBuys/{requestId}")
    .onUpdate(async snapshot => {
        const request = snapshot.data();
        const requestorId = request.requestorId;
        const querySnapshot = await db
                    .collection('users')
                    .doc(requestorId) // change to receiverUid
                    .collection('tokens')
                    .get();

        const payload = {
            notification: {
                title: 'Updates to your request", // add senderName
                body: 'Your request has been ' + request.status,
            },
            data: {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                view: 'request',
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });


//exports.sendGroupBuyNotification = functions.firestore
//    .document("groupBuys/{groupBuyId}")
//    .onUpdate(async (snapshot, context) => {
//
//    });
