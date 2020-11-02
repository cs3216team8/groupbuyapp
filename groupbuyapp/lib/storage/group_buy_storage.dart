import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupbuyapp/models/request.dart';

class GroupBuyStorage {

  GroupBuyStorage._privateConstructor();
  static final GroupBuyStorage instance = GroupBuyStorage._privateConstructor();

  CollectionReference groupBuys = FirebaseFirestore.instance.collection(
      'groupBuys');

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
          'address': groupBuy.address,
          'status': GroupBuy.stringFromGroupBuyStatus(groupBuy.status),
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
      'address': groupBuy.address,
      'status': GroupBuy.stringFromGroupBuyStatus(groupBuy.status),
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
            document.data()['address'],

            GroupBuy.groupBuyStatusFromString(document.data()['status']),
        );
      }).toList();
    });
  }

  // Future<void> editBuy(Buy buy) {
  //   String buyId = buy.id;
  //   String groupBuyId = buy.groupBuyId;
  //   return groupBuys.doc(groupBuyId).set({
  //     'id': buyId,
  //     'buyerId': buy.buyerId,
  //     'itemLink': buy.itemLink,
  //     'amount': buy.amount,
  //     'quantity': buy.quantity,
  //     'comment': buy.comment,
  //   })
  //       .then((value) => print("By edited"))
  //       .catchError((error) => print("Failed to edit buy: $error"));
  // }
  //
  // Future<void> deleteBuy(Buy buy) {
  //   String buyId = buy.id;
  //   String groupBuyId = buy.groupBuyId;
  //   return groupBuys.doc(groupBuyId).collection('buys').doc(buyId).delete()
  //       .then((value) => print("By deleted"))
  //       .catchError((error) => print("Failed to delete buy: $error"));
  // }

  Future<Request> getRequestWithItems(String groupBuyId, QueryDocumentSnapshot document) async {
    QuerySnapshot groupBuyRequestItems = await groupBuys.doc(groupBuyId).collection('requests').doc(document.id).collection('items').get();
    List<QueryDocumentSnapshot> itemDocs = groupBuyRequestItems.docs;
    List<Item> items = itemDocs.map((doc) {
      return new Item(
        itemLink: doc.data()['itemLink'],
        totalAmount: doc.data()['totalAmount'].toDouble(),
        qty: doc.data()['qty'],
        remarks: doc.data()['remarks'],
      );
    }).toList();
    return new Request(
      id: document.id,
      requestorId: document.data()['requestorId'],
      items: items,
      status: Request.requestStatusFromString(document.data()['status']),
    );
  }

  /// Get group buy details and all buys under this group buy, this is called if the user is the organiser
  Future<List<Future<Request>>> getAllGroupBuyRequests(GroupBuy groupBuy) {
    CollectionReference groupBuyRequestsCollection = groupBuys.doc(groupBuy.id).collection('requests');
    return groupBuyRequestsCollection.get().then((snapshot) {
      List<Future<Request>> futureRequests = snapshot.docs.map((document) async {
        QuerySnapshot groupBuyRequestItems = await groupBuyRequestsCollection.doc(document.id).collection('items').get();
        List<Item> items = groupBuyRequestItems.docs.map((itemDocument) {
          return Item(
              itemLink: itemDocument.data()['itemLink'],
              totalAmount: itemDocument.data()['totalAmount'].toDouble(),
              qty: itemDocument.data()['qty'],
              remarks: itemDocument.data()['remarks']
          );
        }).toList();

        return Request(
            id: document.id,
            requestorId: document.data()['requestorId'],
            items: items,
            status: Request.requestStatusFromString(document.data()['status'])
        );
      }).toList();

      return futureRequests;
    });
  }

  /// Show only buys which is created by this user, if the user is the piggybacker, there is supposed to be only 1
  Future<Request> getGroupBuyRequestsFromCurrentUser(GroupBuy groupBuy) {
    String userId = FirebaseAuth.instance.currentUser.uid;
    String groupBuyId = groupBuy.getId();

    return groupBuys.doc(groupBuyId).collection('requests').where('requestorId', isEqualTo:userId)
        .get().then((QuerySnapshot querySnapshot) {
          List<Future<Request>> futureRequests = querySnapshot.docs.map((doc) async {
            QuerySnapshot groupBuyRequestItems = await groupBuys.doc(groupBuyId).collection('requests').doc(doc.id).collection('items').get();
            List<QueryDocumentSnapshot> itemDocs = groupBuyRequestItems.docs;
            List<Item> items = itemDocs.map((doc) {
              return new Item(
                itemLink: doc.data()['itemLink'],
                totalAmount: doc.data()['totalAmount'].toDouble(),
                qty: doc.data()['qty'],
                remarks: doc.data()['remarks'],
              );
            }).toList();

            return new Request(
            id: doc.id,
            requestorId: doc.data()['requestorId'],
            items: items,
            status: Request.requestStatusFromString(doc.data()['status']),
            );
          }).toList();
          if (futureRequests.length > 0) {
            return futureRequests[0];
          } else {
            return Future<Null>.value(null);
          }
        });
  }

  Future<void> addRequest(String groupBuyId, Request request) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    request.id = groupBuys.doc(groupBuyId).collection('requests').doc().id;
    DocumentReference requestDoc = groupBuys.doc(groupBuyId).collection('requests').doc(request.id);

    batch.set(requestDoc, {
      'id': request.id,
      'requestorId': request.requestorId,
      'status': Request.stringFromRequestStatus(request.status),
    });

    request.items.forEach((item) {
      String itemId = requestDoc.collection('items').doc().id;
      batch.set(requestDoc.collection('items').doc(itemId), {
        'itemLink': item.itemLink,
        'qty': item.qty,
        'remarks': item.remarks,
        'totalAmount': item.totalAmount,
      });
    });

    batch.commit();
  }

  Future<void> confirmRequest(String groupBuyId, Request request) {
    DocumentReference groupBuyRequest = groupBuys.doc(groupBuyId).collection('requests').doc(request.getId());
    return groupBuyRequest.update({'status': 'confirmed'})
        .then((value) => print("Request edited"))
        .catchError((error) => print("Failed to edit group buy: $error"));
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
            document.data()['address'],

            GroupBuy.groupBuyStatusFromString(document.data()['status']),
        );
      }).toList();
    });
  }

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
              document.data()['address'],

              GroupBuy.groupBuyStatusFromString(document.data()['status']),
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
