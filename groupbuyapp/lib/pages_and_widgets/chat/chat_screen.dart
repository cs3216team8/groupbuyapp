import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:groupbuyapp/storage/chat_storage.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  ChatScreen(this.chatRoomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatUser user = ChatUser();

  @override
  void initState() {
    user.name = FirebaseAuth.instance.currentUser.displayName;
    user.uid = FirebaseAuth.instance.currentUser.uid;
    user.avatar = FirebaseAuth.instance.currentUser.photoURL;
    super.initState();
  }

  void onSendMessage(ChatMessage message) {
    ChatStorage().onSendMessage(message);
  }

  void uploadFile() async {
    ChatStorage().uploadFileToStorage(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .doc('testChatRoom')
            .collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            var messages =
                items.map((i) => ChatMessage.fromJson(i.data())).toList();
            return DashChat(
              user: user,
              messages: messages,
              inputDecoration: InputDecoration(
                hintText: "Message here...",
                border: InputBorder.none,
              ),
              onSend: onSendMessage,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: uploadFile,
                )
              ],
              timeFormat: DateFormat('HH:mm'),
              dateFormat: DateFormat('MMM dd'),
              messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                return BoxDecoration(
                  color: isUser ? Color(0xFFE75480) : Color(0xFFEEEEEE),
                  // example
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                );
              },
            );
          }
        },
      ),
    );
  }
}
