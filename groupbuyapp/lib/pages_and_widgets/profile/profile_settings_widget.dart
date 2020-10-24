import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class ProfileSettingsScreen extends StatelessWidget {
  UserProfile profile;

  ProfileSettingsScreen({
    Key key,
    @required this.profile,
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
            ProfilePicChanger(pic: profile.profilePicture),
            InputHorizontal(itemText: "Username",),
            InputHorizontal(itemText: "Email",),
            SizedBox(height: 20,),
            Expanded(
              child: AddressListModifier(
                addresses: profile.addresses,
              ),
            )
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

class AddressListModifier extends StatefulWidget {
  List<String> addresses;

  AddressListModifier({
    Key key,
    this.addresses,
  }) : super(key: key);

  @override
  _AddressListModifierState createState() => _AddressListModifierState();
}

class _AddressListModifierState extends State<AddressListModifier> {
  final _formKey = GlobalKey<FormState>();
  List<String> deleted = []; // TODO: undoable history

  void _deleteAddress(int index) {
    setState(() {
      String addr = widget.addresses.removeAt(index);
      deleted.add(addr);
    });
  }

  void _addAddress(String addr) {
    setState(() {
      widget.addresses.add(addr);
    });
  }

  Widget _logoutConfirmation(BuildContext context) {
    return new AlertDialog(
      title: const Text('Are you sure you want to logout?'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            await FacebookLogin().logOut();
            print(FirebaseAuth.instance.currentUser);
            Navigator.pop(context);
            segueWithoutBack(context, LoginScreen());
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes'),
        ),
        new FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 10,),
                Text(
                  "List of addresses",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 70,
                    alignment: Alignment(0, 0),
                    color: Colors.orange,
                    child: Text(
                      "To remove an item, swipe the tile to the right or tap the trash icon.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 20.0,
              child: FloatingActionButton(
                child: new Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Add"),
                                        onPressed: () {
                                          if (_formKey.currentState.validate()) {
                                            _formKey.currentState.save();
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  });
                },
                backgroundColor: Colors.amber,
              ),
            ),
          ],
        ),
        // TODO: @kx add undo delete option here
        // TODO: make address editable
        // TODO: fab: allow adding of addresses -- add to top so dunnid scroll
        Expanded(
          child: ListView.builder(
            itemCount: widget.addresses.length,
            itemBuilder: (context, index) {
              final address = widget.addresses[index];
              return Dismissible(
                key: Key(address),
                direction: DismissDirection.startToEnd,
                child: ListTile(
                  title: Text(address),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_rounded),
                    onPressed: () => _deleteAddress(index),
                  ),
                ),
                onDismissed: (direction) {
                  _deleteAddress(index);
                },
              );
            },
          ), //TODO @kx,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _logoutConfirmation(context),
            );
            },
          child: new Text("Logout", textAlign: TextAlign.left),
        )
      ],
    );
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
