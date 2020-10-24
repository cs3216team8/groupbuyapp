import 'package:groupbuyapp/models/activity_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivitiesStorage {
  final String userId = FirebaseAuth.instance.currentUser.uid;

  CollectionReference activityRef =
      FirebaseFirestore.instance.collection('activities');

  Future<void> createActivity(Activity activity) async {
    CollectionReference userActivityRef = activityRef.doc(userId).collection('activity');

    return userActivityRef.add({
      'storeName': activity.storeName,
      'organiserId': activity.organiserId,
      'time': activity.time,
      'originUid': activity.originUid,
      'status': activity.status
    });
  }

  Stream<List<Activity>> getAllActivities() {
    CollectionReference userActivityRef = activityRef.doc(userId).collection(
        'activity');

    return userActivityRef.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return Activity(
          document.data()['storeName'],
          document.data()['organiserId'],
          document.data()['time'],
          document.data()['originUid'],
          document.data()['status'],
          document.id
        );
      }).toList();
    });
  }

  Future<void> updateActivityStatus(Activity activity) async {
    CollectionReference userActivityRef = activityRef.doc(userId).collection('activity');

    if (activity.activityId == null) {
      createActivity(activity);
      return;
    }

    DocumentReference docRef = userActivityRef.doc(activity.activityId);

    return docRef.update({
      'time': activity.time,
      'status': activity.status,
    });
  }
}
