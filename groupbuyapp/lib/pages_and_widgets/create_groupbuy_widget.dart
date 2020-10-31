import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/error_flushbar.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'components/custom_appbars.dart';

class CreateGroupBuyScreen extends StatefulWidget {
  final bool needsBackButton;

  CreateGroupBuyScreen({
    Key key,
    this.needsBackButton = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateGroupBuyState();
}

class _CreateGroupBuyState extends State<CreateGroupBuyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productWebsiteController = TextEditingController();
  final TextEditingController _targetAmt = TextEditingController();
  final TextEditingController _currentAmt = TextEditingController(); //TODO default 0

  DateTime endDate = DateTime.now().add(Duration(days: 3));

  final List<String> supportedSites = ['amazon.sg', 'ezbuy.sg', 'Others'];
  String chosenSite;

  List<String> userAddresses = []; //['blash', 'bifbodauhaasfouabf wetawetw dfsge rywadfsy t qwr jg'];
  String chosenAddress;

  @override
  void initState() {
    chosenSite = supportedSites[0];
    chosenAddress = null; //userAddresses[0];
    fetchAddresses();
  }

  Future<void> _getData() async {
    setState(() {
      fetchAddresses();
    });
  }

  void fetchAddresses() async {
    Future<UserProfile> fprof = ProfileStorage.instance.getUserProfile(FirebaseAuth.instance.currentUser.uid);
    fprof.then((prof) => {
      setState(() {
        userAddresses = prof.addresses;
      })
    });
  }

  void createGroupBuy(BuildContext context) {
    if (chosenAddress == null) {
      showErrorFlushbar(context, "Invalid input", "Address cannot be empty!");
      return;
    }

    print("send create request to db"); //TODO input validation + hook storage

    // GroupBuy groupBuy = GroupBuy(id, storeName, storeWebsite, storeLogo, currentAmount, targetAmount, endTimestamp, organiserId, deposit, description, address);
    // GroupBuyStorage.instance.addGroupBuy(groupBuy);

    if (widget.needsBackButton) {
      Navigator.pop(context);
    } else {
      //clear inputs
      _productWebsiteController.clear();
      _targetAmt.clear();
      _currentAmt.clear();
      segueToPage(context, HomeScreen()); // TODO: redirect instead of pushing
    }
  }

  String getLogoAssetName(String site) {
    switch (site) {
      case 'amazon.sg':
        return 'Amazon-logo.png';
      case 'ezbuy.sg':
        return 'ezbuy-logo.jpg';
      default:
        return '';
    }
  }

  Widget _addressAndSubmitPart() {
    return userAddresses.isEmpty
      ? Text("You have not filled in your address yet! Head over to profile settings to add addresses, or pull to refresh.")

      : Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 10,
          shadowColor: Colors.black12,
          child: Column(
            children: [
              Text(
              'Address'
              ),
              DropdownButton<String>(
                isExpanded: true,
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
            ]
          )
        ),
        RaisedButton(
          child: Text('Create'),
          onPressed: () => createGroupBuy(context),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.needsBackButton
            ? backAppBar(context: context, title: "Start a jio!")
            : regularAppBar(
            context: context,
            titleElement: Text("Start a jio!", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white))
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButton<String>(
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
                  ),
                  chosenSite == 'Others'
                      ? RoundedInputField(
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

                  Card(
                      color: Colors.white,
                      elevation: 10,
                      shadowColor: Colors.black12,
                      child: Column(
                          children: [
                            Text(
                                'Target Amount'
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: _targetAmt,
                            ),
                            ]
                        )
                    ),
                    Card(
                        color: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.black12,
                        child: Column(
                            children: [
                              Text(
                                  'Current Amount'
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: _currentAmt,
                              ),
                            ]
                        )
                    ),
                    Card(
                        color: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.black12,
                        child: Column(
                            children: [
                              Text(
                                  'Date end'
                              ),
                              InputDatePickerFormField(
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                                initialDate: endDate,
                              ),
                            ]
                        )
                    ),
                    _addressAndSubmitPart()
                  ]
              )
            )
        )
      )
    );
  }
}