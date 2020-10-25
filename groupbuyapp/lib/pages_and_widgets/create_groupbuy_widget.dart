import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';

class CreateGroupBuyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateGroupBuyState();
}

class _CreateGroupBuyState extends State<CreateGroupBuyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productWebsiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
          key: _formKey,
          child: Column(
              children: [
                Image.asset(
                  'assets/Amazon-logo.png',
                  height: 100.0,
                ),

                RoundedInputField(
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
                ),
                RoundedInputField(
                  color: Color(0xFFFBE3E1),
                  iconColor: Theme.of(context).primaryColor,
                  hintText: "Website",
                  controller: _productWebsiteController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter website';
                    }
                    if (Uri.parse(value).isAbsolute) {
                      return 'Please enter a valid website';
                    }
                    return null;
                  },
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
                          TextField(

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
                              'Address'
                          ),
                          TextField(

                          ),
                        ]
                    )
                ),
                RaisedButton(
                    child: Text('Create'),
                    onPressed: null
                )
              ]
          )
        )
      )
    );
  }
}