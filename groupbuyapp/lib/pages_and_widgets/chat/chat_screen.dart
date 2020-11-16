import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuyapp/storage/chat_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String username;

  ChatScreen({this.chatRoomId, this.username});

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
    message.text = message.text.trim();
    if (message.text != "") {
      ChatStorage().onSendMessage(message, widget.chatRoomId);
    }
  }

  void uploadFile() async {
    ChatStorage().uploadFileToStorage(user, widget.chatRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Chat with ${widget.username}",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(widget.chatRoomId)
            .collection('messages')
            .snapshots(),
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
              messageImageBuilder: (String string, [ChatMessage chatMessage]) {
                return GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        imageUrl: chatMessage.image,
                      ),
                    ),
                    onTap: () {
                      segueToPage(context, DetailScreen(chatMessage.image));
                    });
              },
              messageTextBuilder: (String string, [ChatMessage]) {
                return Text(
                  string,
                  style: Styles.chatMessageStyle,
                );
              },
              messageTimeBuilder: (String string, [ChatMessage]) {
                return Text(
                  string,
                  style: Styles.chatTimeStyle,
                );
              },
              inputTextStyle: Styles.chatMessageStyle,
              messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                return BoxDecoration(
                  color: isUser ? Color(0xFFFFF3E7) : Color(0xFFFBECE6),
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

class DetailScreen extends StatefulWidget {
  final String imageUrl;

  DetailScreen(this.imageUrl);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => Center(child: Container(width: 12, height: 12,child: new CircularProgressIndicator())),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}