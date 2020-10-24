import 'dart:async';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/buy_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';

class UserProfileStorage {
  CollectionReference users = FirebaseFirestore.instance.collection(
      'users');
  String userId = "";

  // String userId = FirebaseAuth.instance.currentUser.uid;

  Future<UserProfile> getUserProfile(String userId) async {
    DocumentSnapshot document = await users
        .doc(userId)
        .get();
    UserProfile userProfile = new UserProfile(
        userId,
        document.data()['name'],
        document.data()['username'],
        document.data()['profilePicture'],
        document.data()['phoneNumber'],
        document.data()['email'],
        document.data()['addresses'],
        document.data()['groupBuyIds'],
        document.data()['rating'],
        document.data()['reviewCount']
    );
    return userProfile;
  }

  Future<void> editUserProfile(UserProfile userProfile) async {
    String userId = userProfile.id;
    return users.doc(userId).set({
      'name': userProfile.name,
      'username': userProfile.username,
      'profilePicture': userProfile.profilePicture,
      'phoneNumber': userProfile.phoneNumber,
      'email': userProfile.email,
      'addresses': userProfile.addresses,
      'groupBuyIds': userProfile.groupBuyIds,
      'rating': userProfile.rating,
      'reviewCount': userProfile.reviewCount,
    })
        .then((value) => print("User profile edited"))
        .catchError((error) => print("Failed to edit user: $error"));
  }

  Future<void> addReview(Review review, String userId) async {
    DocumentSnapshot document = await users
        .doc(userId)
        .get();
    double currentRating = document.data()['rating'];
    double currentReviewCount = document.data()['reviewCount'];
    double newRating = ((currentRating * currentReviewCount) +
        review.getRating()) / (currentReviewCount + 1);
    return users.doc(userId).set({
      'rating': newRating,
      'reviewCount': currentReviewCount + 1,
    });
  }
}