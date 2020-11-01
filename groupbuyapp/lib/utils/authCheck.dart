import 'package:firebase_auth/firebase_auth.dart';

bool isUserLoggedIn() {
  User currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return false;
  } else {
    return true;
  }
}
