import 'package:groupbuyapp/models/activity_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivitiesStorage{

  CollectionReference activityRef = FirebaseFirestore.instance.collection(
      'activities');
  String userId = FirebaseAuth.instance.currentUser.uid;

  Future<void> createActivity(Activity activity) async {

  }

  Future<List<Activity>> getAllActivities() async {

  }

}