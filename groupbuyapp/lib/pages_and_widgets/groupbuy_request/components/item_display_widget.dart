import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sprintf/sprintf.dart';

class ItemDisplay extends StatelessWidget {
  final Item item;

  ItemDisplay({
    Key key,
    @required this.item,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => launch(this.item.itemLink),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(bottom: 5),
          child: Card(
            color: Colors.white,
            elevation: 10,
            shadowColor: Colors.black12,
            child: Container(
              padding: EdgeInsets.only(left:10, right: 10, top: 3, bottom: 3),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Location
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6, left: 3, right: 3, bottom: 6),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.open_in_new,
                                      color: Color(0xFFe87d74),
                                      size: 24.0,
                                      semanticLabel: 'Items',
                                    )
                                  ],
                                ),
                                onTap: () => launch(this.item.itemLink),
                              ),
                            ),
                            Container(height: 40, child: VerticalDivider(color: Color(0xFFe87d74))),
                            Container(
                              padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(sprintf('%spcs', [this.item.qty]), style: Styles.textStyle, textAlign: TextAlign.left,),
                                      SizedBox(height: 7),
                                      Text(this.item.remarks, style: Styles.textStyle),
                                    ]
                                  ),
                                ]
                              )
                            )
                          ]
                        )
                      ),
                      Container(child: Text("\$${(this.item.totalAmount * this.item.qty).toString()}", style: Styles.textStyle, textAlign: TextAlign.right),),
                    ],
                  ),
                ]
              )
            )
          )
        )
    );
  }
}