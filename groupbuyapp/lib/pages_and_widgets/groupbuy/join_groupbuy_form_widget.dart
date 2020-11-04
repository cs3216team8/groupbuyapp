import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/add_item_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () => submitJoinRequest(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_turned_in_outlined),
                  Text("Confirm"),
                ],
              ),
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 80, left: 0, right: 0),
            // padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                    'Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 20,),

                Container(
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
                        background: Container(color: Colors.black26),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: itemCard,
                          trailing: IconButton(
                            icon: Icon(Icons.delete_rounded),
                            onPressed: () => _deleteInputCard(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                OutlineButton(
                    child: Text('+ Add more items',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: addItemInput
                ),
                Row(
                    children: [
                      Expanded(flex: 70, child: Text('Total: ')),
                      Expanded(flex: 30, child: Text('\$57.90'))
                    ]
                ),
                Row(
                    children: [
                      Expanded(flex: 70, child: Text('Deposit Amount:')),
                      Expanded(flex: 30, child: Text('\$28.95'))
                    ]
                ),
              ],
            )
        ),
      ),
    );
  }
}