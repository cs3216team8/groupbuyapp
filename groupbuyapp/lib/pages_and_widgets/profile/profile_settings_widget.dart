import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';

class ProfileSettingsScreen extends StatelessWidget {
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
            ProfilePicChanger(),
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
  @override
  Widget build(BuildContext context) {
    return Container();
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
          Text(itemText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
          SizedBox(width: 10,),
          Expanded(
            child: TextField(
              decoration: InputDecoration(),
            ),
          )
        ],
      ),
    );
  }
}
