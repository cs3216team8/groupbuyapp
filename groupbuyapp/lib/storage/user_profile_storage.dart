import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';

class ProfileStorage {
  CollectionReference usersRef = FirebaseFirestore.instance.collection(
      'users');

  Future<UserProfile> getUserProfile(String userId) async {
    DocumentSnapshot document = await usersRef
        .doc(userId)
        .get();
    UserProfile userProfile = new UserProfile(
        userId,
        document.data()['name'],
        document.data()['username'],
        document.data()['profilePicture'],
        document.data()['phoneNumber'],
        document.data()['email'],
        List.from(document.data()['addresses']),
        List.from(document.data()['groupBuyIds']),
        document.data()['rating'],
        document.data()['reviewCount']
    );
    return userProfile;
  }

  Future<bool> checkIfProfileExists(String userId) async {
    DocumentReference docRef = usersRef.doc(userId);
    DocumentSnapshot doc = await docRef.get();

    return doc.exists;
  }

  Future<void> createOrUpdateUserProfile(UserProfile userProfile) async {
    String userId = userProfile.id;
    return usersRef.doc(userId).set({
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
    DocumentSnapshot document = await usersRef
        .doc(userId)
        .get();
    double currentRating = document.data()['rating'];
    double currentReviewCount = document.data()['reviewCount'];
    double newRating = ((currentRating * currentReviewCount) +
        review.getRating()) / (currentReviewCount + 1);
    return usersRef.doc(userId).set({
      'rating': newRating,
      'reviewCount': currentReviewCount + 1,
    });
  }
}