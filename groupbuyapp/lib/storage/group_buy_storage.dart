import 'dart:async';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupBuyStorage {
  CollectionReference groupBuys = FirebaseFirestore.instance.collection(
      'groupBuys');
  String userId = FirebaseAuth.instance.currentUser.uid;

  Future<void> addGroupBuy(GroupBuy groupBuy) {
    String groupBuyId = groupBuys.doc().id;
    return groupBuys.doc(groupBuyId).set({
      'id': groupBuyId,
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
        .then((value) => print("Group buy added"))
        .catchError((error) => print("Failed to add group buy: $error"));
  }

  Future<void> editGroupBuy(GroupBuy groupBuy) {
    String groupBuyId = groupBuy.id;
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
        .then((value) => print("Group buy edited"))
        .catchError((error) => print("Failed to edit group buy: $error"));
  }

  Future<void> deleteGroupBuy(GroupBuy groupBuy) {
    String groupBuyId = groupBuy.id;
    return groupBuys.doc(groupBuyId).delete()
        .then((value) => print("Group buy edited"))
        .catchError((error) => print("Failed to edit group buy: $error"));
  }

  Stream<List<GroupBuy>> getAllGroupBuys() {
    return groupBuys.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return GroupBuy(
            document.id,
            document.data()['storeName'],
            document.data()['storeWebsite'],
            document.data()['storeLogo'],
            document.data()['currentAmount'].toDouble(),
            document.data()['targetAmount'].toDouble(),
            document.data()['endTimestamp'],
            document.data()['username'],
            document.data()['deposit'],
            document.data()['description'],
            document.data()['address']
        );
      }).toList();
    });
  }
}
