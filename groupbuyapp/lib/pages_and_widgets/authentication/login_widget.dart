import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/components/login_signup_option_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/signup_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/components/social_icon_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:groupbuyapp/utils/auth/logins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:groupbuyapp/utils/themes.dart';
import 'components/login_background.dart';

class LoginPage extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: LoginScreen(),
      theme: Themes.loginTheme
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
  List<Widget> socialLoginWidgets = <Widget>[];

  @override
  void didChangeDependencies() {
    loadSocialLoginWidgets();
  }

  Future<void> loadSocialLoginWidgets() async {
    List socialLoginWidgets = <Widget>[];
    socialLoginWidgets.addAll(<Widget>[
      SocialIcon(
          icon: SvgPicture.asset(
            "assets/facebook.svg",
            height: 20,
            width: 20,
            color: Colors.white,
          ),
          outlineColor: Color.fromRGBO(59, 89, 152, 1),
          backgroundColor: Color.fromRGBO(59, 89, 152, 1),
          onPress: onPressFacebookLogin
      ),
      SizedBox(width: 5),
      SocialIcon(
          icon: SvgPicture.asset(
            "assets/google.svg",
            height: 20,
            width: 20,
          ),
          outlineColor: Theme.of(context).accentColor,
          onPress: onPressGoogleLogin
      ),
    ]);

    if (await AppleSignIn.isAvailable()) {
      socialLoginWidgets.addAll(<Widget>[
        SizedBox(width: 5),
        SocialIcon(
            icon: SvgPicture.asset(
                "assets/apple.svg",
                height: 20,
                width: 20,
                color: Colors.white
            ),
            outlineColor: Colors.black,
            backgroundColor: Colors.black,
            onPress: onPressAppleLogin
        )
      ]);
    }
    print("Loaded Social Widgets");
    setState(() {
      this.socialLoginWidgets = socialLoginWidgets;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        message: message
    ).show(context);
  }

  Future<void> onPressUsernameAndPasswordLogin() async {
    if (_formKey.currentState.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        UserCredential credential = await Logins.signInWithEmailAndPassword(email, password);
        checkUserCredentialAndLogin(credential);
      } catch (e) {
        showErrorFlushbar(e.toString());
      }
    }
  }

  Future<void> onPressGoogleLogin() async {
    try {
      checkUserCredentialAndLogin(await Logins.signInWithGoogle());
    } catch (e) {
      showErrorFlushbar(e.toString());
    }
  }

  Future<void> onPressFacebookLogin() async {
    try {
      checkUserCredentialAndLogin(await Logins.signInWithFacebook());
    } catch (e) {
      showErrorFlushbar(e.toString());
    }
  }

  Future<void> onPressAppleLogin() async {
    try {
      checkUserCredentialAndLogin(await Logins.signInWithApple());
    } catch (e) {
      showErrorFlushbar(e.toString());
    }
  }

  void checkUserCredentialAndLogin(UserCredential credential) {
    if (credential != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0,
          toolbarOpacity: 1,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          )
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: size.height * 0.03,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: socialLoginWidgets
                  ),
                  SizedBox(height: 6),
                  OrDivider(
                    textColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 10,),
                  RoundedInputField(
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
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
                    color: Color(0xFFFBE3E1),
                    iconColor: Theme.of(context).primaryColor,
                    controller: _passwordController,
                    validator: (String value) {
                      if (value == "") {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  RoundedButton(
                    color: Theme.of(context).primaryColor,
                    text: "LOGIN WITH EMAIL",
                    onPress: onPressUsernameAndPasswordLogin
                  ),
                  SizedBox(height: 10),
                  LoginOrSignupOption(
                    textColor: Theme.of(context).primaryColor,
                    isLogin: true,
                    onPress: () {
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
