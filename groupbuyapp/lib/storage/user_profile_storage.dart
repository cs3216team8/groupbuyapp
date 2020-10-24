import 'package:flutter/material.dart';

import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets//components/grid_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Widget getUserProfile(BuildContext context, String userId) {
  DocumentReference userProfile = FirebaseFirestore.instance
      .collection('users')
      .doc(userId);

  FutureBuilder<DocumentSnapshot>(
      future: userProfile.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return UserProfileCard(
              new UserProfile(
                data['name'],
                data['username'],
                data['profilePicture'],
                data['phoneNumber'],
                data['email'],
                data['addresses'],
                data['groupBuyIds'],
              )
          );
        }
        return Text("loading");
      }

);
}
