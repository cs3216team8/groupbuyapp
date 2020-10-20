import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/authentication/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages/authentication/signup_widget.dart';
import 'package:groupbuyapp/pages/components/custom_appbars.dart';
import 'package:groupbuyapp/pages/components/input_widgets.dart';

import 'background.dart';

class LoginScreen extends StatelessWidget {
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
                  onChanged: (value) {
                    print("username input changed: ${value}");
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    print("pw input changed: ${value}");
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  onPress: () {
                    print("login button pressed");
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
                        builder: (context) => SignupScreen()
                      )
                    );
                  },
                ),
              ],
            ),
          )
        )
    );
  }
}
