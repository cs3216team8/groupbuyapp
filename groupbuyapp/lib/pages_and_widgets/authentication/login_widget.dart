import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/signup_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/social_icon_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:flushbar/flushbar.dart';

import 'background.dart';

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

  Future<User> _signInWithEmailAndPassword() async {
    try {
      return (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorFlushbar("User not found");
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

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print('logged in');
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
          title: const Text('PiggyBuy'),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                            segueToPage(context, PiggyBuyApp());
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
                            segueToPage(context, PiggyBuyApp());
                          }
                        } catch (e) {
                          showErrorFlushbar(e.toString());
                        }
                      },
                    )
                  ],
                ),
                SizedBox(height: 6,),
                OrDivider(),
                SizedBox(height: 10,),
                RoundedInputField(
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
                  controller: _passwordController,
                  validator: (String value) {
                    if (value == "") {

                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  onPress: () async {
                    if (_formKey.currentState.validate()) {
                      User user = await _signInWithEmailAndPassword();
                      if (user != null) {
                        segueToPage(context, PiggyBuyApp());
                      }
                    }
                  },
                  color: Theme.of(context).primaryColor,
                ),
                LoginOrSignupOption(
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
