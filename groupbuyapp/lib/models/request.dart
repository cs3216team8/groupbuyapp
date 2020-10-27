import 'package:flutter/material.dart';

class Request {
  String id;
  List<Item> items;
  RequestStatus status;

  static Request getDummyRequest() {
    return Request(
        id: "dummyuid",
        items: [
          Item(url: 'someurl', totalAmount: 15.08, qty: 1, remarks: "someremarks"),
          Item(url: 'someurl2', totalAmount: 3.60, qty: 2, remarks: "someremark2"),
        ],
        status: RequestStatus.confirmed,
    );
  }

  Request({
    @required this.id,
    @required this.items,
    @required this.status,
  });

  String getId() {
    return this.id;
  }

  String getStatus() {
    return status.toString().split('.').last;
  }

  double getTotalAmount() {
    return items.fold(0, (previousValue, item) => previousValue + item.totalAmount);
  }

}

enum RequestStatus {
  pending, confirmed, completed, rejected, accepted
}

class Item {
  String url;
  double totalAmount;
  int qty;
  String remarks;

  Item({
    @required this.url,
    @required this.totalAmount,
    @required this.qty,
    @required this.remarks,
  });
}
