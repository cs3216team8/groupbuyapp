import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';

class ProfileStorage {

  ProfileStorage._privateConstructor();
  static final ProfileStorage instance = ProfileStorage._privateConstructor();

  CollectionReference usersRef = FirebaseFirestore.instance.collection(
      'users');
  StorageReference profilePhotoRef = FirebaseStorage.instance.ref().child('profile-pics');

  Future<Profile> getUserProfile(String userId) async {

    DocumentSnapshot document = await usersRef
        .doc(userId)
        .get();
    Profile userProfile = new Profile(
        userId,
        document.data()['name'],
        document.data()['username'],
        document.data()['profilePicture'],
        document.data()['phoneNumber'],
        document.data()['email'],
        document.data()['authType'],
        List.from(document.data()['addresses']),
        List.from(document.data()['groupBuyIds']),
        document.data()['rating'],
        document.data()['reviewCount']
    );
    return userProfile;
  }

  Future<bool> checkIfUsernameIsTaken(String username) async {
    QuerySnapshot query = await usersRef.where('username', isEqualTo: username).get();
    if (query.size != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfProfileExists(String userId) async {
    DocumentReference docRef = usersRef.doc(userId);
    DocumentSnapshot doc = await docRef.get();

    return doc.exists;
  }

  Future<void> createOrUpdateUserProfile(Profile userProfile) async {
    String userId = userProfile.userId;

    if (userId != FirebaseAuth.instance.currentUser.uid) {
      throw Exception("Trying to update a user that is not you!");
    }

    return usersRef.doc(userId).set({
      'name': userProfile.name,
      'username': userProfile.username,
      'profilePicture': userProfile.profilePicture,
      'phoneNumber': userProfile.phoneNumber,
      'email': userProfile.email,
      'authType': userProfile.authType,
      'addresses': userProfile.addresses,
      'groupBuyIds': userProfile.groupBuyIds,
      'rating': userProfile.rating,
      'reviewCount': userProfile.reviewCount,
    }).then((value) => print("User profile created/updated successfully."))
        .catchError((error) {
          throw Exception(error.toString());
    });
  }

  Future<String> uploadProfilePhoto(File photo) async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    StorageUploadTask uploadTask = profilePhotoRef.child(userId).putFile(photo);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> updateProfilePhotoUrl(String photoUrl) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    return await usersRef.doc(userId).update({
      'profilePicture': photoUrl,
    });
  }

  Future<void> addReview(Review review, String userId) async {
    DocumentSnapshot document = await usersRef
        .doc(userId)
        .get();
    double currentRating = document.data()['rating'];
    double currentReviewCount = document.data()['reviewCount'];
    double newRating = ((currentRating * currentReviewCount) +
        review.getRating()) / (currentReviewCount + 1);
    return usersRef.doc(userId).update({
      'rating': newRating,
      'reviewCount': currentReviewCount + 1,
    });
  }
}