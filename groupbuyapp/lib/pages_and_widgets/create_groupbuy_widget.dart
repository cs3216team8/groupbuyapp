import 'package:flutter/material.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
import 'components/custom_appbars.dart';

class CreateGroupBuy extends StatelessWidget {
  final GroupBuyStorage groupBuyStorage;
  final ProfileStorage profileStorage;

  CreateGroupBuy({
    Key key,
    @required this.groupBuyStorage,
    @required this.profileStorage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegularAppBar(
          context: context,
          titleElement: Text("Start a jio!", style: TextStyle(color: Colors.black),)
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  children: [
                    Image.asset(
                      'assets/Amazon-logo.png',
                      height: 100.0,
                    ),
                    Card(
                        color: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.black12,
                        child: Column(
                            children: [
                              Text(
                                  'Website'
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
      ),
    );
  }
}