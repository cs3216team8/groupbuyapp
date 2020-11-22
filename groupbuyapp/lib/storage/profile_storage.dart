import 'dart:async';
import 'package:async/async.dart';
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
  Reference profilePhotoRef = FirebaseStorage.instance.ref().child('profile-pics');
  CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');

  CollectionReference requestsRoot = FirebaseFirestore.instance.collection('requests');

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
        document.data()['rating']!=null? document.data()['rating'].toDouble(): null,
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
      'rating': userProfile.rating,
      'reviewCount': userProfile.reviewCount,
    }).then((value) => print("User profile created/updated successfully."))
        .catchError((error) {
          throw Exception(error.toString());
    });
  }

  Future<String> uploadProfilePhoto(File photo) async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    UploadTask uploadTask = profilePhotoRef.child(userId).putFile(photo);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> updateProfilePhotoUrl(String photoUrl) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    return await usersRef.doc(userId).update({
      'profilePicture': photoUrl,
    });
  }

  Future<void> addReviewForOrganiser(Review review, String userId) async {
    DocumentSnapshot document = await usersRef
        .doc(userId)
        .get();
    double currentRating = document.data()['rating']!= null? document.data()['rating'] : 0;
    int currentReviewCount = document.data()['reviewCount'];
    double newRating = ((currentRating * currentReviewCount) +
        review.getRating()) / (currentReviewCount + 1);
    await reviews.add({
      'revieweeUserId': review.revieweeUserId,
      'reviewerUserId': FirebaseAuth.instance.currentUser.uid,
      'rating': review.rating,
      'review': review.review,
      'dateTime': review.dateTime,
      'role': 'organiser'
    });
    return usersRef.doc(userId).update({
      'rating': newRating,
      'reviewCount': currentReviewCount + 1,
    });
  }

  Future<void> addReviewForPiggybacker(Review review, String userId) async {
    DocumentSnapshot document = await usersRef
        .doc(userId)
        .get();
    double currentRating = document.data()['rating']!= null? document.data()['rating'] : 0;
    int currentReviewCount = document.data()['reviewCount'];
    double newRating = ((currentRating * currentReviewCount) +
        review.getRating()) / (currentReviewCount + 1);
    await reviews.add({
      'revieweeUserId': review.revieweeUserId,
      'reviewerUserId': FirebaseAuth.instance.currentUser.uid,
      'rating': review.rating,
      'review': review.review,
      'dateTime': review.dateTime,
      'role': 'piggybacker'
    });
    return usersRef.doc(userId).update({
      'rating': newRating,
      'reviewCount': currentReviewCount + 1,
    });
  }

  Stream<Review> reviewForOrganiser(String userId) {
    Stream<QuerySnapshot> querySnapshots = reviews
        .where('role', isEqualTo: 'organiser')
        .where('reviewerUserId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('revieweeUserId', isEqualTo:userId)
        .snapshots();
    return querySnapshots.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      else {
        return snapshot.docs.map((doc) {
          return new Review(
            doc.data()['revieweeUserId'],
            doc.data()['reviewerUserId'],
            doc.data()['rating'],
            doc.data()['review'],
            doc.data()['dateTime'].toDate(),

          );
        }).toList()[0];
      }
    });
  }

  Stream<Review> reviewForPiggybacker(String userId) {
    Stream<QuerySnapshot> querySnapshots = reviews
        .where('role', isEqualTo: 'piggybacker')
        .where('reviewerUserId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('revieweeUserId', isEqualTo:userId)
        .snapshots();
    return querySnapshots.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      else {
        return snapshot.docs.map((doc) {
          return new Review(
            doc.data()['revieweeUserId'],
            doc.data()['reviewerUserId'],
            doc.data()['rating'],
            doc.data()['review'],
            doc.data()['dateTime'].toDate(),

          );
        }).toList()[0];
      }
    });
  }

  Stream<List<Review>> getReviewsForPiggybackers(String userId) {
    return reviews
        .where('role', isEqualTo: 'piggybacker')
        .where('revieweeUserId', isEqualTo:userId)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review(
          doc.data()['revieweeUserId'],
          doc.data()['reviewerUserId'],
          doc.data()['rating'],
          doc.data()['review'],
          doc.data()['dateTime'].toDate(),
        );
      }).toList() ;
    });
  }

  Stream<List<Review>> getReviewsForOrganisers(String userId) {
    return reviews
        .where('role', isEqualTo: 'organiser')
        .where('revieweeUserId', isEqualTo:userId)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review(
          doc.data()['revieweeUserId'],
          doc.data()['reviewerUserId'],
          doc.data()['rating'],
          doc.data()['review'],
          doc.data()['dateTime'].toDate(),
        );
      }).toList() ;
    });
  }


}