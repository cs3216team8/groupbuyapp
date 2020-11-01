import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_screen.dart';
import 'package:groupbuyapp/storage/chat_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Stream chatRooms;
  Stream users;

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      segueToPage(context, LoginScreen());
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Column(
                children: <Widget>[
                  chatRoomsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getChatRooms();
    getUsers();
    super.initState();
  }

  getChatRooms() async {
    String currentUserId = FirebaseAuth.instance.currentUser.uid;
    ChatStorage().getUserChats(currentUserId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()}");
      });
    });
  }

  getUsers() async {
    ChatStorage().getUserInfo().then((snapshots) {
      setState(() {
        users = snapshots;
      });
    });
  }

  Widget chatRoomsList() {
    String currentUserId = FirebaseAuth.instance.currentUser.uid;

    return StreamBuilder(
        stream: users,
        builder: (usersContext, usersSnapshot) {
          return StreamBuilder(
            stream: chatRooms,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String senderId = snapshot.data.documents[index]
                            .data()['chatRoomId']
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(currentUserId, "");
                        // print(usersSnapshot.data[senderId]);
                        // FirebaseFirestore.instance.collection("users").where("id", isEqualTo: senderId).get();

                        dynamic userInfo = usersSnapshot.data.documents
                            .where((x) {
                              return x.documentID == senderId;
                            })
                            .toList()[0]
                            .data();
                        String username = userInfo["username"];
                        String profilePic = userInfo["profilePicture"];
                        return ChatRoomsTile(
                          userName: username,
                          chatRoomId: snapshot.data.documents[index]
                              .data()["chatRoomId"],
                        );
                      })
                  : Container(
                      child:
                          Text("There are no group buys that you have joined."),
                    );
            },
          );
        });
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(30)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(userName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
