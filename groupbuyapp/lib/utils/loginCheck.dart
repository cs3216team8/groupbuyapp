import 'package:firebase_auth/firebase_auth.dart';

bool checkLogin() {
  String userId = FirebaseAuth.instance.currentUser.uid;

  if (userId == null) {
    return false;
  } else {
    return true;
  }
}
