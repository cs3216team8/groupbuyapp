import 'package:flutter/material.dart';

class AddItemCard extends StatelessWidget {
  final TextEditingController urlController;
  final TextEditingController qtyController;
  final TextEditingController remarksController;
  final TextEditingController totalAmtController;

  AddItemCard({
    Key key,
    this.urlController,
    this.qtyController,
    this.remarksController,
    this.totalAmtController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Paste your item link here',
                    hintText: 'Product link',
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your quantity here',
                    hintText: 'Qty'
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: TextField(
                  controller: remarksController,
                  expands: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter any comments or options to indicate to the buyer',
                    hintText: 'Remarks/options/comments'
                  )
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: totalAmtController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the product price here',
                    hintText: 'Total amt,'
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}
