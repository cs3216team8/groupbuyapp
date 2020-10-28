import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/components/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/signup_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/components/social_icon_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:flushbar/flushbar.dart';
import 'components/login_background.dart';

class LoginPage extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: LoginScreen(),
      theme: ThemeData(
        primaryColor: Colors.pink,
        accentColor: Color(0xFFF2B1AB),
        cardColor: Color(0xFFFFE1AD),
        backgroundColor: Color(0xFFF4E9E7),
        buttonColor: Color(0xFFBE646E),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String emailErrorMessage = '';
  String passwordErrorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential> _signInWithEmailAndPassword() async {
    try {

      UserCredential user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ));
      // print(user);
      // print(FirebaseAuth.instance.currentUser.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorFlushbar("User not found");
      } else if (e.code == 'invalid-password') {
        showErrorFlushbar("Wrong password");
      }
      else {
        showErrorFlushbar(e.message);
      }
    }
  }

  void showErrorFlushbar(String message) {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: EdgeInsets.only(top: 60, left: 8, right: 8),
        duration: Duration(seconds: 3),
        animationDuration: Duration(seconds: 1),
        borderRadius: 8,
        backgroundColor: Color(0xFFF2B1AB),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        title: "Login failed",
        message: message).show(context);
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn(
        scopes: [
          'email',
        ]).signIn();

    if (googleUser !=  null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      // UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: false, profile: {given_name: Agnes, locale: en, family_name: Natasya, picture: https://lh3.googleusercontent.com/-ebDtfoHeJe4/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucn1hd9DMkL0oBkEf-vD_CwMqcgLPw/s96-c/photo.jpg, aud: 584043471672-btgbhhtb0vnh2mbqmjkc32j5rbhfjngq.apps.googleusercontent.com, azp: 584043471672-vc4ajmg84bk51nvml8g3beshqaqvcnk4.apps.googleusercontent.com, exp: 1603630635, iat: 1603627035, iss: https://accounts.google.com, sub: 109095081159135266046, name: Agnes Natasya, email: an.agnesnatasya@gmail.com, email_verified: true}, providerId: google.com, username: null), credential: AuthCredential(providerId: google.com, signInMethod: google.com, token: null), user: User(displayName: Gabe Miguel, email: an.agnesnatasya@gmail.com, emailVerified: true, isAnonymous: false, metadata: UserMetadata(creationTime: 2020-10-23 00:27:51.939, lastSignInTime: 2020-10-25 20:05:18.872), phoneNumber: null, photoURL: https://lh3.googleusercontent.com/-ebDtfoHeJe4/
      bool isExistingUser = await ProfileStorage.instance.checkIfProfileExists(FirebaseAuth.instance.currentUser.uid);

      if (!isExistingUser) {
        UserProfile userProfile = new UserProfile(
            userCredential.user.uid,
            userCredential.user.displayName,
            "",
            userCredential.additionalUserInfo.profile['picture'],
            userCredential.user.phoneNumber,
            userCredential.user.email,
            [],
            [],
            null,
            0
        );
        try {
          await ProfileStorage.instance.createOrUpdateUserProfile(userProfile);
          return userCredential;
        } catch (e) {
          print(e);
        }
      }

      return userCredential;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print('logged in');
        final token = result.accessToken.token;
        final OAuthCredential credential = FacebookAuthProvider.credential(token); // _token is your facebook access token as a string
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        bool isExistingUser = await ProfileStorage.instance.checkIfProfileExists(FirebaseAuth.instance.currentUser.uid);

        if (!isExistingUser) {
          UserProfile userProfile = new UserProfile(
              userCredential.user.uid,
              userCredential.user.displayName,
              "",
              userCredential.additionalUserInfo.profile['picture']['data']['url'],
              userCredential.user.phoneNumber,
              userCredential.user.email,
              [],
              [],
              null,
              0
          );
          try {
            await ProfileStorage.instance.createOrUpdateUserProfile(userProfile);
            return userCredential;
          } catch (e) {
            print(e);
          }
        }
        return userCredential;
        break;

      case FacebookLoginStatus.cancelledByUser:
        print('cancel');
        break;

      case FacebookLoginStatus.error:
        print('error');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0,
          toolbarOpacity: 1,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ),
        body: Background(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN WITH",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: size.height * 0.03,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        iconSrc: "assets/facebook.svg",
                        onPress: () async {
                          try {
                            UserCredential userCredential = await signInWithFacebook();
                            if (userCredential != null) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            showErrorFlushbar(e.toString());
                          }
                        },
                      ),
                      SocialIcon(
                        iconSrc: "assets/google-plus.svg",
                        onPress: () async {
                          try {
                            UserCredential userCredential = await signInWithGoogle();
                            if (userCredential != null) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            showErrorFlushbar(e.toString());
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 6),
                  OrDivider(
                    textColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 10,),
                  RoundedInputField(
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    hintText: "Your Username or Email",
                    controller: _emailController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  RoundedPasswordField(
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    controller: _passwordController,
                    validator: (String value) {
                      if (value == "") {

                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  RoundedButton(
                    color: Theme.of(context).primaryColor,
                    text: "LOGIN",
                    onPress: () async {
                      if (_formKey.currentState.validate()) {
                        UserCredential userCredential = await _signInWithEmailAndPassword();
                        if (userCredential != null) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                  LoginOrSignupOption(
                    textColor: Theme.of(context).primaryColor,
                    isLogin: true,
                    onPress: () {
                      print("should seg to signup now");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupForm()
                        )
                      );
                    },
                  ),
                ],
              ),
          )
        )
      )
    );
  }
}

class PiggyBuyWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset("assets/piggybuylogo.png", scale: 3,),
          ),
        ],
      ),
    );
  }
}
