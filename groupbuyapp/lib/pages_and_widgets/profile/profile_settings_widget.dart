import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/input_widgets.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/sliver_utils.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final Profile profile;

  ProfileSettingsScreen({
    Key key,
    @required this.profile,
  }) : super(key: key);

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  TextEditingController nameController, usernameController, phoneNumberController;

  List<String> addresses;
  final _formKey = GlobalKey<FormState>();
  TextEditingController addAddressController;
  List<String> deleted = []; // TODO: undoable history
  String profilePicUrl = "";

  void _deleteAddress(int index) {
    setState(() {
      String addr = addresses.removeAt(index);
      deleted.add(addr);
    });
  }

  void _addAddress(BuildContext context, String addr) {
    Navigator.of(context).pop();
    setState(() {
      addresses.add(addr);
    });
  }

  @override
  void initState() {
    super.initState();

    addresses = widget.profile.addresses;
    profilePicUrl = widget.profile.profilePicture;

    nameController = TextEditingController(text: widget.profile.name);
    usernameController = TextEditingController(text: widget.profile.username);
    phoneNumberController = TextEditingController(text: widget.profile.phoneNumber);
  }

  void _onSaveProfile(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    Profile newProfile = Profile(
        widget.profile.userId,
        nameController.text,
        usernameController.text,
        widget.profile.profilePicture,
        phoneNumberController.text,
        widget.profile.email,
        widget.profile.authType,
        widget.profile.addresses,
        widget.profile.groupBuyIds,
        widget.profile.rating,
        widget.profile.reviewCount
      );
      ProfileStorage.instance.createOrUpdateUserProfile(newProfile);
      Navigator.pop(context);
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
              Phoenix.rebirth(context);
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

  Widget _changeProfilePicturePopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
          value: 1,
          child: Row(
              children: [
                Icon(Icons.camera_alt),
                Text('  Camera'),
              ]
          )
      ),
      PopupMenuItem(
          value: 2,
          child: Row(
              children: [
                Icon(Icons.insert_photo),
                Text('  Gallery'),
              ]
          )
      ),
    ],
    onSelected: (value) async {
      PickedFile photo;

      if (value == 1) {
        var status = await Permission.camera.status;

        if (status.isUndetermined) {
        }
        photo = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        photo = await ImagePicker().getImage(source: ImageSource.gallery);
      }

      String photoUrl = await ProfileStorage.instance.uploadProfilePhoto(File(photo.path));
      await ProfileStorage.instance.updateProfilePhotoUrl(photoUrl);
      setState( () {
        profilePicUrl = photoUrl;
      });
    },
    icon: Icon(Icons.insert_photo),
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
        context: context,
        elevation: 0,
        title: 'My Profile',
        color: Color(0xFFFFF3E7),
        actions: [
          FlatButton(
            child: Text(
              "SAVE",
              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'Nunita'), //TODO check font family correct or not
            ),
            onPressed: () => _onSaveProfile(context),
          )
        ]
      ),
      // resizeToAvoidBottomInset: false, // THIS IS THE LINE CAUSING IT NOT TO AUTOSCROLL
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
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
                                  backgroundImage: Image.network(profilePicUrl).image,
                                  child: _changeProfilePicturePopup(),
                                  )
                                ),
                              )
                        ]
                      )
                    ),
                    SizedBox(height: 60,),
                    Center(
                      child: Text(
                        "${widget.profile.email}",
                        style:Styles.usernameStyle
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children : [
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
                              if (value.length > 12) {
                                print("ARE YOU");
                                return 'Username can not be longer than 12 characters';
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
                        ]
                      )
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _logoutConfirmation(context),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(border: Border.all(color: Color(0xFFF98B83)), borderRadius: BorderRadius.circular(10)),
                        child: new Text("LOGOUT",
                            textAlign: TextAlign.center,
                            style: Styles.minorStyle
                        )
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 60.0,
              maxHeight: 83.0,
              child: Container(
                color: Color(0xFFFAFAFA),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Column(
                          children: [
                            Container(
                              child: Text("LIST OF ADDRESSES", style: Styles.subtitleStyle,)
                            ),
                          ]
                        ),
                        SizedBox(width: 60,),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 30,
                          height: 30,
                          child: FloatingActionButton(
                            child: new Icon(Icons.add, color: Colors.white,),
                            onPressed: () {
                              setState(() {
                                GlobalKey<FormState> addrFormKey = GlobalKey<FormState>();
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
                                              key: addrFormKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          return 'Address cannot be empty!';
                                                        }
                                                        return null;
                                                      },
                                                      controller: addAddressController,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: RaisedButton(
                                                      child: Text("Add Address", style: TextStyle(color: Colors.white)),
                                                      onPressed: () {
                                                        if (addrFormKey.currentState.validate()) {
                                                          addrFormKey.currentState.save();
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
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '*SWIPE RIGHT TO DELETE ADDRESS',
                              style: Styles.smallNoticeStyle,
                              textAlign: TextAlign.left,
                            )
                        ),
                        SizedBox(width: 45,),
                      ],
                    ),
                  ]
                ),
              )
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final address = addresses[index];
                  return Column(
                    children: [
                      Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Dismissible(
                        key: Key(address),
                        direction: DismissDirection.startToEnd,
                        background: Container(color: Colors.black26,),
                        child:  SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8 * 0.8,
                          child: Row(
                            children: [
                              Icon(Icons.location_city, color: Color(0xFFF98B83)),
                              SizedBox(width: 10,),
                              Flexible(
                                  child: Text(address),
                              )
                            ]
                          )
                        ),
                        onDismissed: (direction) {
                          _deleteAddress(index);
                        },
                      )
                  ),
                        index != addresses.length-1? Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8 * 0.8,

                          child: Divider(thickness: 0.5, color: Colors.grey)
                        )
                  ): Container()

                      ]);
                },
              childCount: addresses.length
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20,),
              ]
            ),
          )
        ],
      ),
    );
  }
}
