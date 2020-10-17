import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupBuy {
  final String storeName;
  final String storeWebsite;
  final String storeLogo;
  final double currentAmount;
  final double targetAmount;
  final double endTimestamp;
  final String username;
  final double deposit;
  final String description;
  final String address;

  GroupBuy(
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

  GroupBuy getDummyData() {
    return new GroupBuy(storeName, storeWebsite, storeLogo, currentAmount, targetAmount, endTimestamp, username, deposit, description, address)
  }
}