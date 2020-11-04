import 'package:firebase_auth/firebase_auth.dart';

bool isUserLoggedIn() {
  User currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return false;
  } else {
    return true;
  }
}

bool isUserEmailVerified() {
  if (FirebaseAuth.instance.currentUser == null) {
    throw Exception("Error: Not logged in.");
  }

  return FirebaseAuth.instance.currentUser.emailVerified;
}
