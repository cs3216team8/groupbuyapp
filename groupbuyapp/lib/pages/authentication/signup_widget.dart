import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/authentication/login_widget.dart';
import 'package:groupbuyapp/pages/authentication/social_icon_widget.dart';
import 'package:groupbuyapp/pages/components/custom_appbars.dart';
import 'package:groupbuyapp/pages/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'background.dart';
import 'login_signup_option_widget.dart';


class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        title: "Sign up now!",
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
                "SIGN UP WITH",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocialIcon(
                    iconSrc: "assets/facebook.svg",
                    onPress: () {
                      print("clicked facebook");
                    },
                  ),
                  SocialIcon(
                    iconSrc: "assets/google-plus.svg",
                    onPress: () {
                      print("clicked google");
                    },
                  )
                ],
              ),
              SizedBox(height: 6,),
              OrDivider(),
              SizedBox(height: 10,),
              RoundedInputField(
                hintText: "Your Username or Email",
                validator: (String value) {
                  print(value);
                  if (value.isEmpty) {
                    return('Please enter your username or email');
                  }
                  return null;
                },
                onChanged: (value) {
                  print("username input changed: ${value}");
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  print("pw input changed: ${value}");
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  print("pw2 input changed: ${value}");
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter password confirmation';
                  }
                  return null;
                },
                hintText: "Confirm password",
              ),
              RoundedInputField(
                hintText: "HP number rmb to add send otp button",
                onChanged: (value) {
                  print("hp input changed: ${value}");
                },
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter phone number or email address';
                  }
                  return null;
                },
              ),
              RoundedButton(
                text: "SIGN UP",

                onPress: () async {
                  if (_formKey.currentState.validate()) {
                    _register();
                  }
                },
                color: Theme.of(context).primaryColor,
              ),
              LoginOrSignupOption(
                isLogin: false,
                onPress: () {
                  print("should seg to login now");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()
                      )
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}
