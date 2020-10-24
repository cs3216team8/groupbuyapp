import 'package:flutter/material.dart';

class AddItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text('Item link'),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Paste your item link here'),
          ),
          Text('Amount'),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the product price here'),
          ),
          Text('Quantity'),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your quantity here'),
          ),
          Text('Comments/Options'),
          TextField(
            expands: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:
                    'Enter any comments or options to indicate to the buyer'),
          ),
          RaisedButton(
              color: Colors.pinkAccent, child: Text('Add'), onPressed: null)
        ],
      ),
    );
  }
}
