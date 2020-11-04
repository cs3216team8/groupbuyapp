import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_screen.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatStorage {
  // for chat screen
  void onSendMessage(ChatMessage message, String chatRoomId) {
    var documentReference = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  void uploadFileToStorage(ChatUser user, String chatRoomId) async {
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
          .doc(chatRoomId)
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
    print("hi");
    return await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("members", arrayContains: myId)
        .snapshots();
  }

  Future<bool> addChatRoom(Map<String, dynamic> chatRoom, String chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .set(chatRoom);
  }

  getUserInfo() async {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  // For broadcast
  broadcast(String msg, GroupBuy groupBuy, Profile organiserProfile) async {
    print("hallo");
    await createChatRoomForPiggyBackers(groupBuy);
    QuerySnapshot chatRooms = await FirebaseFirestore.instance
        .collection("chatRooms")
        .where("groupBuyId", isEqualTo: groupBuy.id)
        .get();

    chatRooms.docs.forEach((element) {
      String chatRoomId = element.get("chatRoomId");
      ChatUser chatUser = ChatUser(
          uid: organiserProfile.userId,
          name: organiserProfile.username,
          avatar: organiserProfile.profilePicture);
      ChatMessage message = ChatMessage(text: msg, user: chatUser);
      onSendMessage(message, chatRoomId);
    });
  }

  Future<void> createChatRoomForPiggyBackers(GroupBuy groupBuy) async {
    QuerySnapshot usersInGroupBuy = await FirebaseFirestore.instance
        .collection("users")
        .where("groupBuyIds", arrayContains: groupBuy.id)
        .get();
    usersInGroupBuy.docs.forEach((user) async {
      createChatRoom(groupBuy, user.id);
    });
  }

  // for segue to chat
  
  Future<String> createChatRoom(GroupBuy groupBuy, String requestorId) async {
    String groupBuyId = groupBuy.id;
    String organiserId = groupBuy.organiserId;
    String userId = requestorId;
    String chatRoomId = organiserId + "_" + userId;
    List<String> members = [organiserId, userId];
    Map<String, dynamic> chatRoom = {
      "chatRoomId": chatRoomId,
      "members": members,
      "groupBuyId": groupBuyId,
    };
    await (new ChatStorage()).addChatRoom(chatRoom, chatRoomId);
    return chatRoomId;
  }

  void createAndOpenChatRoom(
    BuildContext context, GroupBuy groupBuy, String requestorId, bool isToOrganiser) async {
    String receiverId = isToOrganiser ? groupBuy.organiserId : requestorId;
    Profile receiverProfile =
        await ProfileStorage.instance.getUserProfile(receiverId);
    String chatRoomId = await createChatRoom(groupBuy, requestorId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
            chatRoomId: chatRoomId, username: receiverProfile.username),
      ),
    );
  }
}
