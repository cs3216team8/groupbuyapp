import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:groupbuyapp/utils/auth/auth_check.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final Profile profile;

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
              Profile newProfile = Profile(
                  profile.userId,
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
              ProfileStorage.instance.createOrUpdateUserProfile(newProfile);
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
            Container(
                constraints: BoxConstraints.loose(Size.fromHeight(53.9/ 140.23 *MediaQuery. of(context).size.width)),
                decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/banner-profile.png', ))),
                child:
                Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                          bottom: -50,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundImage: Image.network(profile.profilePicture).image,
                            ),
                          )
                      )
                    ]
                )
            ),
            SizedBox(height: 60,),
            Container(
              child: Text(
                  "${profile.email}",
                  style:Styles.usernameStyle
              ),
            ),

            RoundedInputField(
              color: Color(0xFFFBE3E1),
              iconColor: Theme.of(context).primaryColor,
              hintText: "New Name",
              controller: nameController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your new name';
                }
                return null;
              },
            ),
            RoundedInputField(
              color: Color(0xFFFBE3E1),
              iconColor: Theme.of(context).primaryColor,
              hintText: "New Username",
              controller: usernameController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your new username';
                }
                return null;
              },
            ),
            RoundedInputField(
              color: Color(0xFFFBE3E1),
              icon: Icons.phone,
              iconColor: Theme.of(context).primaryColor,
              hintText: "New Phone Number",
              controller: phoneNumberController,
              validator: (String value) {
                return null;
              },
            ),
            // InputHorizontal(itemText: "Name", controller: nameController, enabled: true),
            // InputHorizontal(itemText: "Username", controller: usernameController, enabled: true),
            // InputHorizontal(itemText: "Phone Number", controller: phoneNumberController, enabled: true),
            // InputHorizontal(itemText: "Email", controller: emailController, enabled: false),
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

class ProfilePicChanger extends StatefulWidget {
  final String pictureUrl;

  ProfilePicChanger({
    Key key,
    this.pictureUrl,
  }) : super(key: key);

  @override
  _ProfilePicChangerState createState() => _ProfilePicChangerState();

}

class _ProfilePicChangerState extends State<ProfilePicChanger> {

  String pictureUrl;

  void initState() {
    pictureUrl = widget.pictureUrl;
  }

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
              backgroundImage: Image.network(pictureUrl).image,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Column(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  PickedFile photo = await ImagePicker().getImage(source: ImageSource.camera);
                  String photoUrl = await ProfileStorage.instance.uploadProfilePhoto(File(photo.path));
                  await ProfileStorage.instance.updateProfilePhotoUrl(photoUrl);
                  setState( () {
                    pictureUrl = photoUrl;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.image_search),
                onPressed: () async {
                  PickedFile photo = await ImagePicker().getImage(source: ImageSource.camera);
                  String photoUrl = await ProfileStorage.instance.uploadProfilePhoto(File(photo.path));
                  await ProfileStorage.instance.updateProfilePhotoUrl(photoUrl);
                  setState( () {
                    pictureUrl = photoUrl;
                  });
                  },
              ),
            ],
          )
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
  TextEditingController addAddressController;
  List<String> deleted = []; // TODO: undoable history

  void _deleteAddress(int index) {
    setState(() {
      String addr = widget.addresses.removeAt(index);
      deleted.add(addr);
    });
  }

  void _addAddress(BuildContext context, String addr) {
    Navigator.of(context).pop();
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
            segueWithoutBack(context, PiggyBuyApp());
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
            Container(
              width: MediaQuery.of(context).size.width *0.8,
              padding: EdgeInsets.all(20),

              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text("LIST OF ADDRESSES", style: Styles.subtitleStyle,)
                  ),
                  Container(

                    width: 30,
                        height: 30,
                        child: FloatingActionButton(
                        child: new Icon(Icons.add, color: Colors.white,),
                        onPressed: () {
                          setState(() {
                            addAddressController = TextEditingController();
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
                                            addAddressController = null;
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
                                              child: TextFormField(
                                                controller: addAddressController,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Add Address", style: TextStyle(color: Colors.white)),
                                                onPressed: () {
                                                  if (_formKey.currentState.validate()) {
                                                    _formKey.currentState.save();
                                                    _addAddress(context, addAddressController.text);
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
                        backgroundColor: Color(0xFFF98B83),
                      ),
                    )


                  ]),
                    )],
              ),


        // TODO: @kx add undo delete option here & make address editable & fab: allow adding of addresses -- add to top so dunnid scroll
        Expanded(
          child: ListView.builder(
            itemCount: widget.addresses.length,
            itemBuilder: (context, index) {
              final address = widget.addresses[index];
              return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Dismissible(
                key: Key(address),
                direction: DismissDirection.startToEnd,
                background: Container(color: Colors.black26,),
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
              )
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
          child: Container(
            color: Color(0xFFCDCDCD),
            child:
            InkWell(

            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            child: Container(

              width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
                child: Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: TextStyle(

                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 16
                    )
                )
            ),
          )
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
