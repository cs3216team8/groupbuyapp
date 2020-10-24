import 'package:flutter/material.dart';

class LoginOrSignupOption extends StatelessWidget {
  final bool isLogin;
  final Function onPress;
  const LoginOrSignupOption({
    Key key,
    this.isLogin = true,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLogin ? "Don't have an Account?" : "Already have an account?",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        GestureDetector(
          onTap: onPress,
          child: Text(
            isLogin ? "Sign up" : "Sign in",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}