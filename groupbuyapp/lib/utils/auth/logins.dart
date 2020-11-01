import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groupbuyapp/utils/profile/profile_builder.dart';

class Logins {
  static Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password));
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("User not found");
      } else if (e.code == 'invalid-password') {
        throw Exception("Wrong password");
      } else {
        throw Exception(e.message);
      }
    }
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn(scopes: ['email']).signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      bool isExistingUser = await ProfileStorage.instance.checkIfProfileExists(FirebaseAuth.instance.currentUser.uid);
      if (!isExistingUser) {
        final profile = ProfileBuilder.buildNewUserProfile(
            userId: userCredential.user.uid,
            name: userCredential.user.displayName,
            username: ProfileBuilder.createUsernameFromName(userCredential.user.displayName),
            email: userCredential.user.email,
            phoneNumber: userCredential.user.phoneNumber,
            profilePicture: userCredential.additionalUserInfo.profile['picture']
        );
        await ProfileStorage.instance.createOrUpdateUserProfile(profile);
      }

      return userCredential;
    }
  }

  static Future<UserCredential> signInWithFacebook() async {
    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        // token is your facebook access token as a string
        final token = result.accessToken.token;
        final OAuthCredential credential = FacebookAuthProvider.credential(token);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        bool isExistingUser = await ProfileStorage.instance.checkIfProfileExists(FirebaseAuth.instance.currentUser.uid);

        if (!isExistingUser) {
          final profile = ProfileBuilder.buildNewUserProfile(
              userId: userCredential.user.uid,
              name: userCredential.user.displayName,
              username: ProfileBuilder.createUsernameFromName(userCredential.user.displayName),
              email: userCredential.user.email,
              phoneNumber: userCredential.user.phoneNumber,
              profilePicture: userCredential.additionalUserInfo.profile['picture']['data']['url']
          );
          await ProfileStorage.instance.createOrUpdateUserProfile(profile);
        }

        return userCredential;
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;

      case FacebookLoginStatus.error:
        throw Exception("There was an error logging in with Facebook");
        break;
    }
  }

  static Future<UserCredential> signInWithApple() async {

    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final oAuthProvider = OAuthProvider('apple.com');
        final oAuthCredential = oAuthProvider.credential(
          idToken: String.fromCharCodes(result.credential.identityToken),
          accessToken: String.fromCharCodes(result.credential.authorizationCode),
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
        bool isExistingUser = await ProfileStorage.instance.checkIfProfileExists(FirebaseAuth.instance.currentUser.uid);

        if (!isExistingUser) {
          final profile = ProfileBuilder.buildNewUserProfile(
              userId: userCredential.user.uid,
              name: ProfileBuilder.createUsernameFromEmail(userCredential.user.email),
              username: ProfileBuilder.createUsernameFromEmail(userCredential.user.email),
              email: userCredential.user.email,
          );
          await ProfileStorage.instance.createOrUpdateUserProfile(profile);
        }

        return userCredential;
        break;

      case AuthorizationStatus.cancelled:
        break;

      case AuthorizationStatus.error:
        throw Exception("Error with Sign-in with Apple.");
        break;
    }
  }

}
