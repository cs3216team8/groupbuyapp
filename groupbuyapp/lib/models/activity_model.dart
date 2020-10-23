import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String storeName;
  final bool organiserId;
  final Timestamp time;
  final String originUid; // from who did this activity come from?
  String status;
  String activityId;

  Activity(this.storeName, this.organiserId, this.time, this.originUid, this.status, [String activityId]);

  DateTime getTime() {
    return this.time.toDate();
  }

}