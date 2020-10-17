import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class GetAllGroupBuys extends StatelessWidget {

  GetAllGroupBuys();

  @override
  Widget build(BuildContext context) {
    CollectionReference groupBuys = FirebaseFirestore.instance.collection('groupBuys');

    return FutureBuilder<DocumentSnapshot>(
      future: groupBuys.doc().get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Group Buy: ${data['storeName']} ${data['storeWebsite']}");
        }

        return Text("loading");
      },
    );
  }
}
