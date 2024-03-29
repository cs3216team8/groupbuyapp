import 'package:flutter/material.dart';

class LoginOrSignupOption extends StatelessWidget {
  final bool isLogin;
  final Function onPress;
  final Color textColor;

  const LoginOrSignupOption({
    Key key,
    this.isLogin = true,
    this.onPress,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLogin ? "Don't have an Account? " : "Already have an account? ",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        GestureDetector(
          onTap: onPress,
          child: Text(
            isLogin ? "Sign up" : "Sign in",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}