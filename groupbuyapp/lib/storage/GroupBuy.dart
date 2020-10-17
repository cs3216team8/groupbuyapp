import 'package:flutter/material.dart';

import 'package:groupbuyapp/models/GroupBuy.dart';
import 'package:groupbuyapp/pages/component/grid_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


List<Widget> getAllGroupBuys(BuildContext context) {
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
