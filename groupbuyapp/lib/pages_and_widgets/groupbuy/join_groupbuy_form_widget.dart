import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/add_item_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/utils/styles.dart';

class JoinGroupBuyForm extends StatefulWidget {
  final String groupBuyId;

  JoinGroupBuyForm({
    Key key,
    @required String this.groupBuyId,
  }) : super(key: key);

  @override
  _JoinFormState createState() => _JoinFormState();
}

class _JoinFormState extends State<JoinGroupBuyForm> {
  List<TextEditingController> itemUrlControllers = [];
  List<TextEditingController> itemQtyControllers = [];
  List<TextEditingController> itemRemarksControllers = [];
  List<TextEditingController> itemTotalAmtControllers = [];

  List<Widget> itemCards = [];
  List<Widget> deleted = []; //TODO undo redo also

  @override
  void initState() {
    super.initState();
    itemCards.add(createInputCard());
  }

  void addItemInput() {
    setState(() {
      itemCards.add(createInputCard());

    });
  }

  void submitJoinRequest(BuildContext context) {
    print("submit join request");
    //TODO: validation of ALL items -- add validator

    List<String> urls = itemUrlControllers.map((ctrlr) => ctrlr.text).toList();
    List<int> qtys = itemQtyControllers.map((ctrlr) => int.parse(ctrlr.text)).toList();
    List<String> rmks = itemRemarksControllers.map((ctrlr) => ctrlr.text).toList();
    List<double> amts = itemTotalAmtControllers.map((ctrlr) => double.parse(ctrlr.text)).toList();

    List<Item> items = [];
    for (int i = 0; i < itemCards.length; i++) {
      items.add(Item(itemLink: urls[i], totalAmount: amts[i], qty: qtys[i], remarks: rmks[i]));
    }

    Request request = Request.newRequest(requestorId: FirebaseAuth.instance.currentUser.uid, items: items);

    GroupBuyStorage.instance.addRequest(widget.groupBuyId, request);

    Navigator.pop(context);
  }


  Widget createInputCard() {
    TextEditingController urlController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController rmksController = TextEditingController();
    TextEditingController amtController = TextEditingController();
    itemUrlControllers.add(urlController);
    itemQtyControllers.add(qtyController);
    itemRemarksControllers.add(rmksController);
    itemTotalAmtControllers.add(amtController);

    return AddItemCard(
      key: UniqueKey(),
      urlController: urlController,
      qtyController: qtyController,
      remarksController: rmksController,
      totalAmtController: amtController,
    );
  }


  void _deleteInputCard(int index) {
    setState(() {
      Widget itemCard = itemCards.removeAt(index);
      deleted.add(itemCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
        context: context,
        title: "Join Group Buy",
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(height: MediaQuery.of(context).size.height),
            Container(
            child: Container(
              padding: EdgeInsets.all(
                20,
              ),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
              children: [
                SizedBox(height:5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                    [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                'ITEMS',
                                style: Styles.subtitleStyle,
                                textAlign: TextAlign.left,
                            )
                            ),
                            SizedBox(height: 3),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*SWIPE RIGHT TO DELETE ITEMS',
                                style: Styles.smallNoticeStyle,
                                textAlign: TextAlign.right,
                              )
                            ),
                            ]
                      ),
                      // Container(
                      // width: 30,
                      // height: 30,
                      // child: FloatingActionButton(
                      //   backgroundColor: Color(0xFFF98B83),
                      // child: new Icon(Icons.add, color: Colors.white,),
                      // onPressed: addItemInput
                      // )
                      // )
                    ]
                ),

                SizedBox(height:5),
                Container(
                  alignment: Alignment.center,

                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: itemCards.length,
                    itemBuilder: (context, index) {
                      Widget itemCard = itemCards[index];
                      return Dismissible(
                        key: itemCard.key,
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          _deleteInputCard(index);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: itemCard,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                  [
                    Container(
                    alignment: Alignment.center,
                    child:  GestureDetector(
                        onTap: addItemInput,
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(border: Border.all(color: Color(0xFFF98B83)), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                                children: [
                                  Icon(Icons.add, color: Color(0xFFF98B83)),
                                  new Text("ADD ITEM",
                                textAlign: TextAlign.center,
                                style: Styles.minorStyle)
                                ]
                            )
                        )
                    )
                  )
                    ]
                ),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SUMMARY',
                      style: Styles.subtitleStyle,
                      textAlign: TextAlign.right,
                    )
                ),
                SizedBox(height: 3),
                Container(
                  padding: EdgeInsets.all(
                    20,
                  ),
                  decoration: new BoxDecoration(
                    color: Color(0xFFFBECE6),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                        color: Color(0xFFFFFFFF), width: 0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(
                            1, 1), // changes position of shadow
                      )
                    ],
                  ),
                  child: Column(children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('TOTAL', style: Styles.moneyStyle), Text('\$57.90',style: Styles.moneyStyle)
                    ]
                ),
                SizedBox(height: 7),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('DEPOSIT', style: Styles.moneyStyle),
                      Text('\$28.95', style: Styles.moneyStyle)
                    ]
                ),
              ],
            )
        ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        elevation: 15,
                        padding: EdgeInsets.all(14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.greenAccent,
                        onPressed: () => submitJoinRequest(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.assignment_turned_in_outlined, color: Colors.white),
                            Text(" JOIN", style: Styles.popupButtonStyle, textAlign: TextAlign.left,),
                          ],
                        ),
                      ),
                    ]
                ),
          ]
        )
      ),
    )
    ])
    )
    );
  }
}