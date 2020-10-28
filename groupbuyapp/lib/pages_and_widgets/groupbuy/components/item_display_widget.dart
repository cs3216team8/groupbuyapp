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
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new InkWell(
                child: Text(
                  'Item Link'
                ),
                onTap: () => launch(this.item.itemLink),
              ),
              Spacer(
                flex: 1,
              ),
              FlatButton(
                child: Text(sprintf('Qty: %s', [this.item.qty])),
              ), // supposed to be star
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: Text((this.item.totalAmount * this.item.qty).toString(), textAlign: TextAlign.right,),
              )
            ],
          )
        ],
      ),

      // Column(
      //   children: <Widget>[
      //     Row(
      //       children: <Widget>[
      //         new InkWell(
      //           child: Text(
      //             'Item Link'
      //           ),
      //           onTap: () => launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html'),
      //         ),
      //         Expanded(
      //           child: Text(
      //             'Price'
      //           ),
      //           flex: 30
      //         )
      //       ],
      //     )
      //   ],
      // )
    );
  }
}