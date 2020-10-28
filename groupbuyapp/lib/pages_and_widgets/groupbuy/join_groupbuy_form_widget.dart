import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/add_item_widget.dart';

class JoinGroupBuyForm extends StatefulWidget {

  final String piggybackerUid;

  JoinGroupBuyForm({
    Key key,
    this.piggybackerUid, //TODO
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

  void submitJoinRequest() {
    print("submit join request; hook db"); //TODO

    List<String> urls = itemUrlControllers.map((ctrlr) => ctrlr.text);
    List<int> qtys = itemQtyControllers.map((ctrlr) => int.parse(ctrlr.text));
    List<String> rmks = itemRemarksControllers.map((ctrlr) => ctrlr.text);
    List<double> amts = itemTotalAmtControllers.map((ctrlr) => double.parse(ctrlr.text));

    List<Item> items = [];
    for (int i = 0; i < itemCards.length; i++) {
      items.add(Item(itemLink: urls[i], totalAmount: amts[i], qty: qtys[i], remarks: rmks[i]));
    }

    Request request = Request.newRequest(id: widget.piggybackerUid, items: items);
  }

  void onTapChat(BuildContext context) {
    print("on tap chat with this organiser"); // TODO
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
      urlController: urlController,
      qtyController: qtyController,
      remarksController: rmksController,
      totalAmtController: amtController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(
          context: context,
          title: "Join",
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () => submitJoinRequest(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_turned_in_outlined),
                  Text("Confirm"),
                ],
              ),
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () => onTapChat(context),
              child: Icon(Icons.chat_bubble),
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                    'Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemCards.length,
                    itemBuilder: (context, index) {
                      return itemCards[index];
                    },
                  ),
                ),

                OutlineButton(
                    child: Text('+ Add more items',
                        style: TextStyle(
                          color: Colors.white,
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
