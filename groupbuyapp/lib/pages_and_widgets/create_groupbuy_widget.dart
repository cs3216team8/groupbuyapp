import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/error_flushbar.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'components/custom_appbars.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateGroupBuyScreen extends StatefulWidget {
  final bool needsBackButton;

  CreateGroupBuyScreen({
    Key key,
    this.needsBackButton = false,
  }) : super(key: key);

  @override
  _CreateGroupBuyState createState() => _CreateGroupBuyState();
}

class _CreateGroupBuyState extends State<CreateGroupBuyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productWebsiteController = TextEditingController();
  final TextEditingController _targetAmtController = TextEditingController();
  final TextEditingController _currentAmtController = TextEditingController(); //TODO default 0
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _descrController = TextEditingController();

  DateTime endDate = DateTime.now().add(Duration(days: 3));

  final List<String> supportedSites = ['amazon.sg', 'ezbuy.sg', 'Others'];
  String chosenSite;

  final String newAddressPlaceholder = 'New address';
  List<String> userAddresses = [];

  String chosenAddress;

  @override
  void initState() {
    chosenSite = supportedSites[0];
    chosenAddress = newAddressPlaceholder;
    fetchAddresses();
  }

  // Future<void> _getData() async {
  //   setState(() {
  //     fetchAddresses();
  //   });
  // }

  void fetchAddresses() async {
    Future<Profile> fprof = ProfileStorage.instance.getUserProfile(FirebaseAuth.instance.currentUser.uid);
    fprof.then((prof) => {
      setState(() {
        userAddresses = prof.addresses;
        userAddresses.add(newAddressPlaceholder);
      })
    });
  }

  void createGroupBuy(BuildContext context) async {

    if (chosenAddress == null) {
      showFlushbar(context, "Invalid input", "Address cannot be empty!");
      return;
    }
    if (!_formKey.currentState.validate()) {
      return;
    }

    String storeName = chosenSite;
    if (chosenSite == 'Others') {
      storeName = _productWebsiteController.text; //TODO check if is correct interpretation of fields
    }

    String addr;
    if (chosenAddress == newAddressPlaceholder) {
      addr = _addressController.text;
    } else {
      addr = chosenAddress;
    }

    String logo = 'assets/' + getLogoAssetName(chosenSite);

    GroupBuy groupBuy = GroupBuy.newOpenBuy("", storeName, storeName, logo, double.parse(_currentAmtController.text), double.parse(_targetAmtController.text), Timestamp.fromDate(endDate), FirebaseAuth.instance.currentUser.uid, double.parse(_depositController.text), _descrController.text, addr);
    await GroupBuyStorage.instance.addGroupBuy(groupBuy);

    if (widget.needsBackButton) {
      Navigator.pop(context);
    } else {
      //clear inputs
      _productWebsiteController.clear();
      _targetAmtController.clear();
      _currentAmtController.clear();
      _addressController.clear();
      _depositController.clear();
      _descrController.clear();
      // segueToPage(context, HomeScreen()); // TODO: redirect instead of pushing
      showFlushbar(context, "Success!", "Find it in Me > As organiser.", isError: false);
    }
  }

  String getLogoAssetName(String site) {
    switch (site) {
      case 'amazon.sg':
        return 'Amazon-logo.png';
      case 'ezbuy.sg':
        return 'ezbuy-logo.png';
      default:
        return 'placeholder-image.png';
    }
  }


  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  InputDecoration getInputDecoration(IconData iconData) {
    return InputDecoration(
      errorStyle: TextStyle(height: 0.3),
      prefixIcon: Icon(iconData, color: Theme.of(context).primaryColor),
      fillColor: Theme.of(context).accentColor.withAlpha(60),
      filled: true,
      enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Color(0x00000000), width: 0.0),
      ),
      focusedBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
      ),
      border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),

    );

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextStyle subtitleStyle = TextStyle(fontFamily: 'Grotesk', fontSize: 15.5, color: Color(0xFF800020), fontWeight: FontWeight.w500,); //fontSize: 15, fontWeight: FontWeight.normal);

    return Scaffold(
        appBar: widget.needsBackButton
            ? backAppBar(context: context, title: "Start a jio!")
            : regularAppBar(
            context: context,
            titleElement: Text("Start a jio!", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white))
        ),
        body:
        // RefreshIndicator(
        // onRefresh: _getData,
        // backgroundColor: Colors.black26,
        // child:
      SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center ,//Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,

                children: [
                  chosenSite == 'Others'
                      ? RoundedInputField(
                    icon: Icons.public,
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Product Website",
                    controller: _productWebsiteController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter product website';
                      }
                      if (Uri.parse(value).isAbsolute) {
                        return 'Please enter a valid product website';
                      }
                      return null;
                    },
                  )
                      : Image.asset(
                    'assets/${getLogoAssetName(chosenSite)}',
                    height: 100.0,
                  ),

                  Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      child: DropdownButtonFormField<String>(
                          decoration: getInputDecoration(Icons.local_grocery_store),
                          value: chosenSite,
                          items: supportedSites.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              chosenSite = value;
                            });
                          },
                        )
                  ),

                  RoundedInputField(
                    icon: Icons.pending_rounded,
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Target Amount",
                    controller: _targetAmtController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter target amount';
                      }
                      if (!isNumeric(value)) {
                        return 'Please enter a valid target amount';
                      }
                      return null;
                    },
                  ),


                  RoundedInputField(
                    icon: Icons.monetization_on,
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Current Amount",
                    controller: _currentAmtController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter current amount';
                      }
                      if (!isNumeric(value)) {
                        return 'Please enter a valid current amount';
                      }
                      return null;
                    },
                  ),
                  RoundedInputField(
                    icon: Icons.monetization_on_rounded,
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Deposit percentage",
                    controller: _depositController,
                    validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter the deposit percentage';
                    }
                    if (!isNumeric(value)) {
                      return 'Please enter a valid deposit percentage';
                    }
                      return null;
                    },
                  ),

                  RoundedInputField(
                    icon: Icons.description,
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Description",
                    controller: _descrController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter a description or nil';
                      }
                        return null;
                      },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    child: DropdownButtonFormField<String>(
                      decoration: getInputDecoration(Icons.location_on),
                      value: chosenAddress,
                      items: userAddresses.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          chosenAddress = value;
                        });
                      },
                    ),
                  ),
                  chosenAddress == 'New address'
                      ? RoundedInputField(
                    icon: Icons.location_city,
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Address for meetup",
                    controller: _addressController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter product website';
                      }
                      if (Uri.parse(value).isAbsolute) {
                        return 'Please enter a valid product website';
                      }
                      return null;
                    },
                  )
                      :
                  Container(),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),

                    width: size.width * 0.8,
                    child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 23),
                        color: Theme.of(context).accentColor.withAlpha(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                            print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            print('confirm $date');
                          }, currentTime: DateTime.now());
                        },
                        child: Text(
                          'Pick a deadline!',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () => createGroupBuy(context),
                    child: Text("Create", style: subtitleStyle),
                  ),
                ]
              )
          ),
        )
    // )
    )
    );
  }
}