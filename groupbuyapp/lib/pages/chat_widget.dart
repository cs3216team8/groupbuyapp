import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final String current_user; // placeholder

  ChatScreen(this.current_user);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String currentUser = 'dummy'; //TODO
  List<Message> messages = [
    Message('msg1', DateTime.now(), 'dummy'),
    Message('text', DateTime.now(), '2')
  ];

  Widget _buildMessage(Message message, bool isMe) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0,)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      color: isMe
          ? Colors.black26
          : Colors.black38,
      child: Column(
        children: <Widget>[
          Container(
            decoration: isMe 
            ? BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), topLeft: Radius.circular(15.0))
            ) 
            : BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0), topRight: Radius.circular(30.0))
            ),
            child: Text(message.text),
          ),
          Text(message.time.toString())
        ],
      ),
    );
  }

  void _onMakeOffer() {
    print("make offer button pressed");
  }

  void _onViewBuyer() {
    print("make view buyer pressed");
  }

  Widget topIntroWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Image.asset(
                'assets/Amazon-logo.png',
                height: 80, //scale: 8,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "buyer username",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text("deposit"),
                ),
              ],
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: _onMakeOffer,
              child: Text("Make offer"),
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: _onViewBuyer,
              child: Text("View Buyer"),
            ),
          ],
        ),
      ],
    );
  }

  Widget chatSection() {
    return Container(
      color: Colors.white,
      child: ClipRRect(
        child: ListView.builder(
          reverse: true,
          padding: EdgeInsets.only(top: 15.0),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            final Message message = messages[index];
            final bool isMe = message.sender_uid == currentUser;
            return _buildMessage(message, isMe);
          },
        )
      ),
    ); //idk
  }

  Widget typeSection() {
    return Row();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("sometitle"),
      //   backgroundColor: Theme.of(context).backgroundColor,
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 30,
            child: topIntroWidget(),
          ),
          Expanded(
            flex: 60,
            child: chatSection(),
          ),
          Expanded(
            flex: 10,
            child: typeSection(),
          ),
        ],
      ),
    );
  }
}
