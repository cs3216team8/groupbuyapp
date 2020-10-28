import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'components/custom_appbars.dart';

class CreateGroupBuyScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CreateGroupBuyState();
}

class _CreateGroupBuyState extends State<CreateGroupBuyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productWebsiteController = TextEditingController();

  final List<String> supportedSites = ['amazon.sg', 'ezbuy.sg', 'Others'];
  String chosenSite;

  // TODO: @agnes or @dawo where to get the address from profilestorage :o
  List<String> userAddresses = ['blash', 'bifbodauhaasfouabf wetawetw dfsge rywadfsy t qwr jg'];
  String chosenAddress;

  @override
  void initState() {
    chosenSite = supportedSites[0];
    chosenAddress = userAddresses[0];
  }

  void createGroupBuy() {
    print("send create request to db"); //TODO input validation + hook storage
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: regularAppBar(
            context: context,
            titleElement: Text("Start a jio!", style: TextStyle(color: Colors.black),)
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
                            TextField(),
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
                              TextField(),
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
                              TextField(),
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
                        onPressed: createGroupBuy,
                    )
                  ]
              )
            )
        )
      )
    );
  }
}