import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/buy_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupBuyStorage {
  CollectionReference groupBuys = FirebaseFirestore.instance.collection(
      'groupBuys');
  // String userId = FirebaseAuth.instance.currentUser.uid;

  Future<void> addGroupBuy(GroupBuy groupBuy) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    String groupBuyId = groupBuys.doc().id;
    batch.set(
        groupBuys.doc(groupBuyId), {
          'id': groupBuyId,
          'storeName': groupBuy.storeName,
          'storeWebsite': groupBuy.storeWebsite,
          'storeLogo': groupBuy.storeLogo,
          'currentAmount': groupBuy.currentAmount,
          'targetAmount': groupBuy.targetAmount,
          'endTimestamp': groupBuy.endTimestamp,
          'organiserId': groupBuy.organiserId,
          'deposit': groupBuy.deposit,
          'description': groupBuy.description,
          'address': groupBuy.address
        });
    groupBuy.getBuys().map((buy) {
      DocumentReference buyDocument = groupBuys.doc(groupBuyId).collection('buys').doc();
      String buyId = buyDocument.id;
      batch.set(groupBuys.doc(groupBuyId).collection('buys').doc(buyId), {
        'id': buyId,
        'buyerId': buy.buyerId,
        'itemLink': buy.itemLink,
        'amount': buy.amount,
        'quantity': buy.quantity,
        'comment': buy.comment,
      });
    });

    batch.commit();
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
      'organiserId': groupBuy.organiserId,
      'deposit': groupBuy.deposit,
      'description': groupBuy.description,
      'address': groupBuy.address
    })
        .then((value) => print("Group buy edited"))
        .catchError((error) => print("Failed to edit group buy: $error"));
  }

  Future<void> deleteGroupBuy(String groupBuyId) {
    /* TODO DELETE THE COLLECTIONS TOO */
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
            document.data()['organiserId'],
            document.data()['deposit'],
            document.data()['description'],
            document.data()['address']
        );
      }).toList();
    });
  }

  Future<void> editBuy(Buy buy) {
    String buyId = buy.id;
    String groupBuyId = buy.groupBuyId;
    return groupBuys.doc(groupBuyId).set({
      'id': buyId,
      'buyerId': buy.buyerId,
      'itemLink': buy.itemLink,
      'amount': buy.amount,
      'quantity': buy.quantity,
      'comment': buy.comment,
    })
        .then((value) => print("By edited"))
        .catchError((error) => print("Failed to edit buy: $error"));
  }

  Future<void> deleteBuy(Buy buy) {
    String buyId = buy.id;
    String groupBuyId = buy.groupBuyId;
    return groupBuys.doc(groupBuyId).collection('buys').doc(buyId).delete()
        .then((value) => print("By deleted"))
        .catchError((error) => print("Failed to delete buy: $error"));
  }

  /// Get group buy details and all buys under this group buy, if the user is the organiser
  /// Show only buys which is created by this user, if the user is the piggybacker
  Future<void> getGroupBuyDetail(String groupBuyId, String userId) async{
    try {
      DocumentSnapshot document = await groupBuys.doc(groupBuyId).get();
      GroupBuy groupBuy = new GroupBuy(
          groupBuyId,
          document.data()['storeName'],
          document.data()['storeWebsite'],
          document.data()['storeLogo'],
          document.data()['currentAmount'].toDouble(),
          document.data()['targetAmount'].toDouble(),
          document.data()['endTimestamp'],
          document.data()['organiserId'],
          document.data()['deposit'],
          document.data()['description'],
          document.data()['address']
      );
      if (document.exists) {
        Query filteredBuys = (document.data()['organiserId'] == userId) ?
          groupBuys.doc(groupBuyId).collection('buys') :
          groupBuys.doc(groupBuyId).collection('buys').where('buyerId', isEqualTo:userId);
        List<Buy> buys = await filteredBuys.get()
            .then((QuerySnapshot querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return Buy(
              doc.id,
              doc.data()['buyerId'],
              doc.data()['itemLink'],
              doc.data()['amount'],
              doc.data()['quantity'],
              doc.data()['comment'],
            );
          }).toList();
        });
        groupBuy.setBuys(buys);
      }
    } catch(error) {
      print("Failed to retrieve group buy detail: $error");
    }
  }

  Stream<List<GroupBuy>> getGroupBuysOrganisedBy(String userId) {
    return groupBuys.where('organiserId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return GroupBuy(
            document.id,
            document.data()['storeName'],
            document.data()['storeWebsite'],
            document.data()['storeLogo'],
            document.data()['currentAmount'].toDouble(),
            document.data()['targetAmount'].toDouble(),
            document.data()['endTimestamp'],
            document.data()['organiserId'],
            document.data()['deposit'],
            document.data()['description'],
            document.data()['address']
        );
      }).toList();
    });
  }

  // TODO??????
  Future<Stream<List<GroupBuy>>> getGroupBuysPiggyBackedOnBy(String userId) async {
    DocumentSnapshot currentUser = await FirebaseFirestore.instance.collection(
        'users')
        .doc(userId)
        .get();
    List<String> groupBuyIdsPiggyBackedOn = new List<String>.from(
        currentUser.data()['groupBuyIds']);
    if (groupBuyIdsPiggyBackedOn.length > 0) {
      return groupBuys.where('id', arrayContainsAny: groupBuyIdsPiggyBackedOn)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((document) {
          return GroupBuy(
              document.id,
              document.data()['storeName'],
              document.data()['storeWebsite'],
              document.data()['storeLogo'],
              document.data()['currentAmount'].toDouble(),
              document.data()['targetAmount'].toDouble(),
              document.data()['endTimestamp'],
              document.data()['organiserId'],
              document.data()['deposit'],
              document.data()['description'],
              document.data()['address']
          );
        }).toList();
      });
    } else {
      var completer = new Completer<Stream<List<GroupBuy>>>();

      // At some time you need to complete the future:
      List<GroupBuy> empty = List<GroupBuy>();
      StreamController<List<GroupBuy>> controller = StreamController<List<GroupBuy>>();
      controller.add(empty);
      completer.complete(controller.stream);

          return completer.future;
    }
  }
}
