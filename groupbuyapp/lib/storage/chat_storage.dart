import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatStorage {

  // for chat screen
  void onSendMessage(ChatMessage message) {
    var documentReference = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc("testChatRoom")
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }


  void uploadFileToStorage(ChatUser user) async {
    PickedFile pickedFile = await (new ImagePicker()).getImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 400,
      maxWidth: 400,
    );
    final File result = File(pickedFile.path);

    if (result != null) {
      String id = Uuid().v4().toString();

      final StorageReference storageRef =
      FirebaseStorage.instance.ref().child("chat_images/$id.jpg");

      StorageUploadTask uploadTask = storageRef.putFile(
        result,
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      String url = await download.ref.getDownloadURL();

      ChatMessage message = ChatMessage(text: "", user: user, image: url);

      var documentReference = FirebaseFirestore.instance
          .collection('chatRooms')
          .doc("testChatRoom")
          .collection('messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      });
    }
  }


  // For chat list

  getUserChats(String myId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("members", arrayContains: myId)
        .snapshots();
  }
}