import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/sliver_utils.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy_request/components/add_item_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/utils/stringformatters.dart';
import 'package:groupbuyapp/utils/styles.dart';

class JoinGroupBuyForm extends StatefulWidget {
  final String groupBuyId;
  final double deposit;
  final Function() onSuccessSubmit;
  final Request request;

  JoinGroupBuyForm({
    Key key,
    @required this.groupBuyId,
    @required this.deposit,
    this.onSuccessSubmit,
    this.request,
  }) : super(key: key);

  @override
  _JoinFormState createState() => _JoinFormState();
}

class _JoinFormState extends State<JoinGroupBuyForm> {
  List<TextEditingController> itemUrlControllers = [];
  List<TextEditingController> itemQtyControllers = [];
  List<TextEditingController> itemRemarksControllers = [];
  List<TextEditingController> itemTotalAmtControllers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Widget> itemCards = [];
  List<Widget> deleted = []; //TODO undo redo also
  
  bool isUpdate() {
    return widget.request != null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.request == null) {
      itemCards.add(createInputCard());
    } else {
      // load request
      itemCards.addAll(widget.request.items.map((item) => createInputCard(item: item)));
    }
  }

  void addItemInput() {
    setState(() {
      itemCards.add(createInputCard());

    });
  }

  void submitJoinOrEditRequest(BuildContext context) {
    print("submit join request");
    if (!_formKey.currentState.validate()) {
      return;
    }

    List<String> urls = itemUrlControllers.map((ctrlr) => ctrlr.text).toList();
    List<int> qtys = itemQtyControllers.map((ctrlr) => int.parse(ctrlr.text)).toList();
    List<String> rmks = itemRemarksControllers.map((ctrlr) => ctrlr.text).toList();
    List<double> amts = itemTotalAmtControllers.map((ctrlr) => double.parse(ctrlr.text)).toList();

    List<Item> items = [];
    for (int i = 0; i < itemCards.length; i++) {
      items.add(Item(itemLink: urls[i], totalAmount: amts[i], qty: qtys[i], remarks: rmks[i]));
    }

    if (isUpdate()) {
      widget.request.items = items;
      GroupBuyStorage.instance.editRequest(widget.groupBuyId, widget.request);
    } else {
      Request request = Request.newRequest(requestorId: FirebaseAuth.instance.currentUser.uid, items: items);
      GroupBuyStorage.instance.addRequest(widget.groupBuyId, request);
    }

    Navigator.pop(context);
    if (widget.onSuccessSubmit != null) {
      widget.onSuccessSubmit();
    }
  }
  
  double getTotal() {
    List<double> amts = itemTotalAmtControllers.map((ctrlr) => double.parse(ctrlr.text, (val) => 0)).toList();
    
    return amts.reduce((value, element) => value + element);
  }


  Widget createInputCard({Item item,}) {
    TextEditingController urlController = TextEditingController(text: item != null ? item.itemLink : null);
    TextEditingController qtyController = TextEditingController(text: item != null ? item.qty.toString() : null);
    TextEditingController rmksController = TextEditingController(text: item != null ? item.remarks : null);
    TextEditingController amtController = TextEditingController(text: item != null ? item.totalAmount.toString() : null);
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
      item: item,
    );
  }


  void _deleteInputCard(int index) {
    setState(() {
      Widget itemCard = itemCards.removeAt(index);
      itemUrlControllers.removeAt(index);
      itemQtyControllers.removeAt(index);
      itemRemarksControllers.removeAt(index);
      itemTotalAmtControllers.removeAt(index);
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
      body: Stack(
        children: [
          Container(height: MediaQuery.of(context).size.height),
          CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                    minHeight: 60.0,
                    maxHeight: 80.0,
                    child: Container(
                      color: Color(0xFFFAFAFA),
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height:5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                Container(
                                    width: 30,
                                    height: 30,
                                    child: FloatingActionButton(
                                        backgroundColor: Color(0xFFF98B83),
                                        child: new Icon(Icons.add, color: Colors.white,),
                                        onPressed: addItemInput
                                    )
                                )
                              ]
                          ),
                          SizedBox(height:5),
                        ],
                      ),
                    )
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.center,

                                  child: Form(
                                    key: _formKey,
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
                                  )
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
                                          Text('TOTAL', style: Styles.moneyStyle), Text('\$${printNumber(getTotal(), dp:2)}',style: Styles.moneyStyle)
                                        ]
                                    ),
                                    SizedBox(height: 7),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('DEPOSIT', style: Styles.moneyStyle),
                                          Text('\$${printNumber(getTotal() * widget.deposit, dp:2)}', style: Styles.moneyStyle)
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
                                      onPressed: () => submitJoinOrEditRequest(context),
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
                  ]
                ),
              ),
            ],
          ),
        ]
      )
    );
  }
}