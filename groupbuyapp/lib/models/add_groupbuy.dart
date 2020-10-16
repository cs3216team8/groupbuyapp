import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroupBuy extends StatelessWidget {
  String storeName;
  String storeWebsite;
  String storeLogo;
  double currentAmount;
  double targetAmount;
  double endTimestamp;
  String username;
  double deposit;
  String description;
  String address;
  double latitude;
  double longitude;


  AddGroupBuy(
      this.storeName,
      this.storeWebsite,
      this.storeLogo,
      this.currentAmount,
      this.targetAmount,
      this.endTimestamp,
      this.username,
      this.deposit,
      this.description,
      this.address
      );

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called groupbuys that references the firestore collection
    CollectionReference groupbuys = FirebaseFirestore.instance.collection('groupbuys');

    Future<void> addGroupBuy() {
      // Call the group buy's CollectionReference to add a new user
      return groupbuys
          .adds({
        'storeName': storeName,
        'storeWebsite': storeWebsite,
        'storeLogo': storeLogo,
        'currentAmount': currentAmount,
        'targetAmount': targetAmount,
        'endTimestamp': endTimestamp,
        'username': username,
        'deposit': deposit,
        'description': description,
        'address': address,
        'latitude': #todo,
        'longitude': #todo

      })
          .then((value) => print("Group Buy Added"))
          .catchError((error) => print("Failed to add Group Buy: $error"));
    }

    return FlatButton(
      onPressed: addGroupBuy,
      child: Text(
        "Add Group Buy",
      ),
    );
  }
}