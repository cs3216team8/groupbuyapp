import 'dart:async';

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
    .catchError((error) => print("Failed to add group buy: $error"));
}

FutureOr<List<GroupBuy>> getAllGroupBuys() {
  CollectionReference groupBuys = FirebaseFirestore.instance.collection(
      'groupBuys');
    new FutureOr<List<GroupBuy>>(
      groupBuys.get().then((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot document) {
          return new GroupBuy(
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
          );
        }).toList();
      }

      return Text("loading");
      },
  );
}
