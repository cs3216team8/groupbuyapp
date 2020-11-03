import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';

Color getStatusColor(RequestStatus status) {
  switch (status) {
    case RequestStatus.completed:
      return Colors.green;
    case RequestStatus.confirmed:
      return Colors.blue;
    case RequestStatus.pending:
      return Colors.grey;
    case RequestStatus.rejected:
      return Colors.red;
    case RequestStatus.accepted:
      return Colors.greenAccent;
    default:
      return Colors.black;
  }
}
