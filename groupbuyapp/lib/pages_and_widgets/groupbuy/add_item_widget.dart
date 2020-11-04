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
    return Container(
            padding: EdgeInsets.only(left:5, right: 5, top: 6, bottom: 6),
            margin: EdgeInsets.only(bottom: 10),
            decoration: new BoxDecoration(
              color: Color(0xFFFBECE6),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Color(0xFFFFFFFF), width: 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(1,1), // changes position of shadow
                )
              ],
            ),
            alignment: Alignment.center,
            child:Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: MyTextField(
                      controller: urlController,
                      labelText: 'Item Link',
                      hintText: 'Item link',
                      icon: Icons.web,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: MyTextField(
                        controller: remarksController,
                        //expands: true,
                        labelText: 'Remarks',
                        hintText: 'Remarks/options/comments',
                        icon: Icons.description
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  flex: 2,
                  child: MyTextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      labelText: 'Quantity',
                      hintText: 'Quantity',
                      icon: Icons.check_box_outline_blank
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: MyTextField(
                      controller: totalAmtController,
                      keyboardType: TextInputType.number,
                      labelText: 'Price (total)',
                      hintText: 'Total Price,',
                      icon: Icons.monetization_on
                  ),
                ),

              ]),

            ]
        )
    );
  }
}

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText, labelText;
  TextInputType keyboardType;
  IconData icon;

  MyTextField({
    Key key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.icon
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
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          isDense: true,
          hintText: hintText,
          labelText: labelText,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFFF98B83), width: 1.0),
          ),
        ),
      ),
    );
  }
}