import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets//authentication/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages_and_widgets//authentication/signup_widget.dart';
import 'package:groupbuyapp/pages_and_widgets//components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets//components/input_widgets.dart';

import 'background.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  controller: _usernameOrEmailController,
                ),
                RoundedPasswordField(
                  controller: _passwordController,
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
                        builder: (context) => SignupForm()
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
