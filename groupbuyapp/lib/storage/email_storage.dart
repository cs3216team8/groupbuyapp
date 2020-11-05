import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

class EmailStorage {

  EmailStorage._privateConstructor();
  static final EmailStorage instance = EmailStorage._privateConstructor();

  CollectionReference emailRef = FirebaseFirestore.instance.collection('email');

  Future<void> createNewEmail(GroupBuy groupBuy) {
    emailRef.add({
      "groupBuyId": groupBuy.id,
    });
  }
}