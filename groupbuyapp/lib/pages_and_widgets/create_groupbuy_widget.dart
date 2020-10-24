import 'package:flutter/material.dart';

class CreateGroupBuy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}