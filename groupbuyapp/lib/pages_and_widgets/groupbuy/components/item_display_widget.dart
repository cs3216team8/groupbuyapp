import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
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
    return Container(
            child: Card(
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.black12,
                child: Container(
                    padding: EdgeInsets.only(left:10, right: 10, top: 0, bottom: 6),
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
                      mainAxisSize: MainAxisSize.max,

                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new InkWell(
                              child: Text(
                                  'Item Link'
                              ),
                              onTap: () => launch(this.item.itemLink),
                            ),
                            Text(sprintf('%spcs', [this.item.qty])),
                            Text((this.item.totalAmount * this.item.qty).toString()),// supposed to be star
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(this.item.remarks),
                            )
                          ],
                        ),
                      ],
                    ),
                )
            )
        );
  }
}