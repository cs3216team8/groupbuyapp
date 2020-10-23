import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';

class ProfileSettingsScreen extends StatelessWidget {
  String profilePic;

  ProfileSettingsScreen({
    Key key,
    this.profilePic="https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSNBKe7gN6eknU2jJnH34eLwWg5YjTbp3gWcQ&usqp=CAU" // TODO: placeholder profpic
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        title: "My Profile",
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProfilePicChanger(pic: profilePic),
            InputHorizontal(itemText: "Username",),
            InputHorizontal(itemText: "Email",),
            AddressListModifier(),
          ],
        ),
      ),
    );
  }
}

class ProfilePicChanger extends StatelessWidget {
  String pic;

  ProfilePicChanger({
    Key key,
    this.pic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 50,),
        Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Theme.of(context).accentColor,
            child: CircleAvatar(
              radius: 65,
              backgroundImage: Image.network(pic).image,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: IconButton(
            icon: Icon(Icons.image_search),
            onPressed: () {
              print("TODO: should allow upload/change pic");
            },
          ),
        ),
      ],
    );
  }
}

class AddressListModifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InputHorizontal extends StatelessWidget {
  final String itemText;

  InputHorizontal({
    Key key,
    this.itemText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                itemText,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: TextField(
              decoration: InputDecoration(),
            ),
          )
        ],
      ),
    );
  }
}
