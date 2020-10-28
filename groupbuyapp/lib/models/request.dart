import 'package:flutter/material.dart';

class Request {
  String id;
  String requestorId;
  List<Item> items;
  RequestStatus status;

  static Request getDummyRequest() {
    return Request(
        id: "dummyUid",
        requestorId: "dummyUid",
        items: [
          Item(itemLink: 'someurl', totalAmount: 15.08, qty: 1, remarks: "someremarks"),
          Item(itemLink: 'someurl2', totalAmount: 3.60, qty: 2, remarks: "someremark2"),
        ],
        status: RequestStatus.confirmed,
    );
  }

  Request({
    @required this.id,
    @required this.requestorId,
    @required this.items,
    @required this.status,
  });

  Request.newRequest({
    @required this.requestorId,
    @required this.items,
  }) {
    // this.id = "" //TODO: need to pass in empty id? how will storage create id
    status = RequestStatus.pending;
  }

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
  String itemLink;
  double totalAmount;
  int qty;
  String remarks;

  Item({
    @required this.itemLink,
    @required this.totalAmount,
    @required this.qty,
    @required this.remarks,
  });
}
