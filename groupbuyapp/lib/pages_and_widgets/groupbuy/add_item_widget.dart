import 'package:flutter/material.dart';

class AddItemCard extends StatelessWidget {
  final TextEditingController urlController;
  final TextEditingController qtyController;
  final TextEditingController remarksController;
  final TextEditingController totalAmtController;

  AddItemCard({
    @required Key key,
    this.urlController,
    this.qtyController,
    this.remarksController,
    this.totalAmtController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: MyTextField(
                      controller: urlController,
                      labelText: 'Paste your item link here',
                      hintText: 'Product link',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: MyTextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        labelText: 'Enter your quantity here',
                        hintText: 'Qty'
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: MyTextField(
                        controller: remarksController,
                        //expands: true,
                        labelText: 'Enter any comments or options to indicate to the buyer',
                        hintText: 'Remarks/options/comments'
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: MyTextField(
                        controller: totalAmtController,
                        keyboardType: TextInputType.number,
                        labelText: 'Enter the product price here',
                        hintText: 'Total amt,'
                    ),
                  ),
                ],
              ),
            ]
        )
    );
  }
}

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText, labelText;
  TextInputType keyboardType;

  MyTextField({
    Key key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      //: ,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          labelText: labelText,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.black54, width: 1.0),
          ),
        ),
      ),
    );
  }
}