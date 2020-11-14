import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_screen.dart';
import 'package:groupbuyapp/storage/chat_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';

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
      segueWithLoginCheck(
        context,
        ChatList(),
      );
    }
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
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
          'All Chats',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
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
              return snapshot.hasData && snapshot.data.documents.length > 0
                  ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String senderId = snapshot.data.documents[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(currentUserId, "");

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
                      profilePicUrl: profilePic,
                    );
                  })
                  : Container(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/undraw_Mailbox_re_dvds.svg',
                          height: 180,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "It's quiet in here...",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Start a chat with an organizer",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "on the GroupBuy details page",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String profilePicUrl;

  ChatRoomsTile({this.userName, @required this.chatRoomId, this.profilePicUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(
                      chatRoomId: chatRoomId,
                      username: userName,
                    )));
      },
      child: Container(
        decoration: new BoxDecoration(
          color: Color(0xFFFBECE6),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: Color(0xFFFFFFFF), width: 0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Color(0xFFF98B83),
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: Image
                        .network(profilePicUrl)
                        .image,
                  )
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              userName,
              textAlign: TextAlign.start,
              style: Styles.textStyle,
            )
          ],
        ),
      ),
    );
  }
}
