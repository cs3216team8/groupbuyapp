import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages/components/grid_card_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const TextStyle optionStyle = TextStyle(fontSize:  30, fontWeight: FontWeight.bold);

  GroupBuyStorage groupBuyStorage = GroupBuyStorage();
  void _makeGroupbuyRequest() {
    print("request button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            alignment: Alignment.center,
            child: Text('banner hereii'), //TODO: placeholder for banner
            color: Colors.amberAccent, //TODO: testing idk what this
            //padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 155.0),
            margin: EdgeInsets.all(10.0),
          ),
          Stack(
            children: <Widget>[
              Column( // for no entries, if have entry, make invisible
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Your neighbours have yet to request!', style: optionStyle, textAlign: TextAlign.center,),
                  RaisedButton(
                    onPressed: _makeGroupbuyRequest,
                    textColor: Colors.white,
                    child: Text(
                          'Be the first',
                          style: TextStyle(fontSize: 20)
                      )
                    ),
                ],
              ),
              Container(
                child: StreamBuilder<List<GroupBuy>>(
                  stream: groupBuyStorage.getAllGroupBuys(),
                  builder: (BuildContext context, AsyncSnapshot<List<GroupBuy>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasError) {
                      children = <Widget>[
                        Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                        )
                      ];
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          children = <Widget>[
                            Icon(
                              Icons.info,
                              color: Colors.blue,
                              size: 60,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Select a lot'),
                            )
                          ];
                          break;
                        case ConnectionState.waiting:
                          children = <Widget>[
                            SizedBox(
                              child: const CircularProgressIndicator(),
                              width: 60,
                              height: 60,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting bids...'),
                            )
                          ];
                          break;
                        default:
                          children = snapshot.data.map((GroupBuy groupBuy) {
                            return new GroupBuyCard(groupBuy);
                          }).toList();
                          break;
                      }
                    }
                    return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          childAspectRatio: 6.0/7.0,
                          children: children

                    );
                  },
              )

                  /*List.generate(5, (index) { // placeholder for GridCards[]
                    return GroupbuyCard(placeholder);
                  }*/
                )
            ],
          )
        ],
      ),
    );
  }
}
