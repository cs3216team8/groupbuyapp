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

    Request request = Request.newRequest(requestorId: widget.piggybackerUid, items: items);
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
      appBar: BackAppBar(
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
          margin: EdgeInsets.only(top: 20, bottom: 80, left: 10, right: 10),
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
