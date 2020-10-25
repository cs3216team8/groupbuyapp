import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final UserProfile profile;
  final ProfileStorage profileStorage = ProfileStorage();

  ProfileSettingsScreen({
    Key key,
    @required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: profile.name);
    TextEditingController usernameController = TextEditingController(text: profile.username);
    TextEditingController phoneNumberController = TextEditingController(text: profile.phoneNumber);
    TextEditingController emailController = TextEditingController(text: profile.email);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
          icon: Icon(Icons.save_outlined, color: Colors.black,),
            onPressed: () {
              UserProfile newProfile = UserProfile(
                  profile.id,
                  nameController.text,
                  usernameController.text,
                  profile.profilePicture,
                  phoneNumberController.text,
                  profile.email,
                  profile.addresses,
                  profile.groupBuyIds,
                  profile.rating,
                  profile.reviewCount
              );
              profileStorage.createOrUpdateUserProfile(newProfile);
              Navigator.pop(context);
            },
          )
        ]
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProfilePicChanger(pic: profile.profilePicture),
            InputHorizontal(itemText: "Name", controller: nameController, enabled: true),
            InputHorizontal(itemText: "Username", controller: usernameController, enabled: true),
            InputHorizontal(itemText: "Phone Number", controller: phoneNumberController, enabled: true),
            InputHorizontal(itemText: "Email", controller: emailController, enabled: false),
            SizedBox(height: 20),
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
        SizedBox(width: 60,),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).accentColor,
            child: CircleAvatar(
              radius: 55,
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
      content: Text(
        'Are you sure you want to logout?',
        style: TextStyle(
          fontSize: 18
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text(
            'No',
            style: TextStyle(
            fontSize: 16
            ),
          ),
        ),
        new FlatButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            await FacebookLogin().logOut();
            Navigator.pop(context);
            segueWithoutBack(context, LoginScreen());
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(
            'Yes',
            style: TextStyle(
                fontSize: 16
            ),
          )
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
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 1, color: Colors.black26))
                  ),
                  child: Text(
                    "List of addresses",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                    Container(height: 8,),
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   height: 70,
                  //   alignment: Alignment(0, 0),
                  //   color: Colors.orange,
                  //   child: Text(
                  //     "To remove an item, swipe the tile to the right or tap the trash icon.",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
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
          child: InkWell(
            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                    'Logout',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16
                    )
                )
            ),
          ),
        )
      ],
    );
  }
}

class InputHorizontal extends StatefulWidget {
  final String itemText;
  final TextEditingController controller;
  final bool enabled;

  InputHorizontal({
    Key key,
    this.itemText,
    this.controller,
    this.enabled,
  }) : super(key: key);

  @override
  _InputHorizontalState createState () => _InputHorizontalState();

}

class _InputHorizontalState extends State<InputHorizontal> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                widget.itemText,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: TextField(
              decoration: InputDecoration(),
              controller: widget.controller,
              enabled: widget.enabled,
            ),
          )
        ],
      ),
    );
  }
}
