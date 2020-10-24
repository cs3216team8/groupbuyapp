import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/chat_message.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String currentUser; // placeholder

  ChatScreen(this.currentUser);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String currentUser = 'dummy'; //TODO: substitute with actual user after auth is implemented
  String currentUserText = '';

  List<Message> messages = [
    Message(
        'lorem ipsum is simply dummy text of the printing and typesetting industry. lorem ipsum is simply dummy text of the printing and typesetting industry.',
        DateTime.now(),
        'dummy'),
    Message('fifth message', DateTime.now(), 'other'),
    Message('fourth message', DateTime.now(), 'other'),
    Message('third message', DateTime.now(), 'other'),
    Message('second message', DateTime.now(), 'other'),
    Message('first message', DateTime.now(), 'other')
  ];

  void sendMessage() {
    if (currentUserText == "") {
      return;
    }
    print("send" + currentUserText);
    setState(() { messages.insert(0, Message(currentUserText, DateTime.now(), currentUser));
    messages = messages;} );
    print(messages);
  }

  Widget _buildMessage(Message message, bool isMe) {
    String hour = message.time.hour > 12
        ? (message.time.hour - 12).toString()
        : message.time.hour.toString();
    String meridian = message.time.hour > 12 ? "PM" : "AM";
    return Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
              right: 12.0
            )
          : EdgeInsets.only(top: 8.0, bottom: 8.0, left: 12.0, right: 80.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: isMe
                ? BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFEECE9),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFFDF8E7),
                  ),
            padding: isMe
                ? EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10)
                : EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Text(message.text),
          ),
          Text(hour + ":" + message.time.minute.toString() + " " + meridian)
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

  void _onInputAttach() {
    print("attach img/file? button pressed");
  }

  // void _onSend() {
  //   print("send" + currentUserText);
  //   messages.add(Message(currentUserText, DateTime.now(), currentUser));
  //   print(messages);
  // }

  void _setText(value) {
    print(value);
    currentUserText = value;
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
                height: 50, //scale: 5,
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
              child: Text("Join GroupBuy"),
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
        child: ListView.builder(
          reverse: true, // TODO: note order of messages fetched
          padding: EdgeInsets.only(top: 15.0),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            final Message message = messages[index];
            final bool isMe = message.senderUid == currentUser;
            return _buildMessage(message, isMe);
          },
        ),
    );
  }

  Widget typeSection() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 5.0, top: 5.0, bottom: 5.0),
      child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: _onInputAttach,
            ),
            Expanded(
              child: TextField(
                onChanged: _setText,
                decoration: InputDecoration.collapsed(
                  hintText: "Send a message...",
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              onPressed: sendMessage,
            )
          ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:() {
            Navigator.pop(context);
          },
        ),
        title: Text("Chat with dummy"),
        backgroundColor: Colors.pink // to be changed to something less static
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 135,
            child: topIntroWidget(),
          ),
          Expanded(
            child: chatSection(),
            flex: 50,
          ),
          typeSection(),
        ],
      ),
    );
  }
}
