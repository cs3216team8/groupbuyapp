import 'package:flutter/material.dart';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages/components/grid_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> addGroupBuy(GroupBuy groupBuy) {
  CollectionReference groupBuys = FirebaseFirestore.instance.collection(
      'groupBuys');
  String groupBuyId = groupBuys.doc().id;
  return groupBuys.doc(groupBuyId).set({
    'storeName': groupBuy.storeName,
    'storeWebsite': groupBuy.storeWebsite,
    'storeLogo': groupBuy.storeLogo,
    'currentAmount': groupBuy.currentAmount,
    'targetAmount': groupBuy.targetAmount,
    'endTimestamp': groupBuy.endTimestamp,
    'username': groupBuy.username,
    'deposit': groupBuy.deposit,
    'description': groupBuy.description,
    'address': groupBuy.address
  })
    .then((value) => print("Group buy Added"))
    .catchError((error) => print("Failed to add user: $error"));
}

Future<List<GroupBuy>> getAllGroupBuys(BuildContext context) {
  CollectionReference groupBuys = FirebaseFirestore.instance.collection(
      'groupBuys');
  FutureBuilder<QuerySnapshot>(
    future: groupBuys.get(),
    builder:
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        snapshot.data.documents.map((DocumentSnapshot document) {
          return new GroupBuyCard(
              GroupBuy(
                  document.data()['storeName'],
                  document.data()['storeWebsite'],
                  document.data()['storeLogo'],
                  document.data()['currentAmount'],
                  document.data()['targetAmount'],
                  document.data()['endTimestamp'],
                  document.data()['username'],
                  document.data()['deposit'],
                  document.data()['description'],
                  document.data()['address']
              )
          );
        }).toList();
      }

      return Text("loading");
      },
  );
}
