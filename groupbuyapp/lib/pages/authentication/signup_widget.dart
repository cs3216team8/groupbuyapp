import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/authentication/login_widget.dart';
import 'package:groupbuyapp/pages/authentication/social_icon_widget.dart';
import 'package:groupbuyapp/pages/components/custom_appbars.dart';
import 'package:groupbuyapp/pages/components/input_widgets.dart';

import 'background.dart';
import 'login_signup_option_widget.dart';

class SignupScreen extends StatelessWidget {
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
                    iconSrc: "assets/icons/facebook.svg",
                    onPress: () {
                      print("clicked facebook");
                    },
                  ),
                  SocialIcon(
                    iconSrc: "assets/icons/google-plus.svg",
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
                onChanged: (value) {
                  print("username input changed: ${value}");
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  print("pw input changed: ${value}");
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  print("pw2 input changed: ${value}");
                },
                hintText: "Confirm password",
              ),
              RoundedButton(
                text: "SIGN UP",
                onPress: () {
                  print("signup button pressed");
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
