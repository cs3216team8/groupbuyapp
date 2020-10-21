import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/signup_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/social_icon_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'background.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword() async {
    try {
      final FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

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
    // Trigger the sign-in flow
    print("A");
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: BackAppBar(
          context: context,
          title: "Login now!",
          color: Theme.of(context).primaryColor,
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
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    SocialIcon(
                      iconSrc: "assets/google-plus.svg",
                      onPress: () async {
                        try {
                          UserCredential userCredential = await signInWithGoogle();
                        } catch (e) {
                          print(e);
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
                      return('Please enter your email');
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
                    if (value.isEmpty) {
                      return('Please enter your password');
                    }
                    return null;
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  onPress: () async {
                    if (_formKey.currentState.validate()) {
                      _signInWithEmailAndPassword();
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