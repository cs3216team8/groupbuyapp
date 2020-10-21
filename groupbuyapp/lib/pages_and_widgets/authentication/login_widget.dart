import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/signup_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03,),
                RoundedButton(
                  text: "Login with Google",
                  onPress: () {
                    print("clicked gglogin; consider putting logos to left side");
                  },
                  color: Colors.black12,
                  textColor: Colors.black,
                ),
                RoundedButton(
                  text: "Login with Facebook",
                  onPress: () {
                    print("clicked fblogin");
                  },
                  color: Colors.lightBlue,
                ),
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
