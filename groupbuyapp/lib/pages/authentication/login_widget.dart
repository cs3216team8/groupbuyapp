 import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/components/input_widgets.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed:() {
                Navigator.pop(context);
              },
            ),
            title: Text("Login now!"),
            backgroundColor: Colors.pink // to be changed to something less static
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
                )
              ],
            ),
          )
        )
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          child,
        ],
      ),
    );
  }
}

