import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:flushbar/flushbar.dart';
import 'background.dart';
import 'login_signup_option_widget.dart';


class SignupForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String fullNameErrorMessage = '';
  String usernameErrorMessage = '';
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  String passwordConfirmationErrorMessage = '';
  String phoneNumberErrorMessage = '';

  Future<User> _register() async {
    try {
      return (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      )).user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorFlushbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorFlushbar('The account already exists for that email.');
      }
    } catch (e) {
      showErrorFlushbar(e.toString());
    }

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
        title: "Sign Up failed",
        message: message).show(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


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
                "SIGN UP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              RoundedInputField(
                controller: _fullNameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                hintText: "Full Name",
              ),
              RoundedInputField(
                controller: _usernameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                hintText: "Username",
              ),
              RoundedInputField(
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
                  hintText: "Email"
              ),
              RoundedPasswordField(
                controller: _passwordController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return '\n\nPlease enter password';
                  }
                  return null;
                },
              ),
              RoundedPasswordField(
                controller: _passwordConfirmController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return '\n\nPlease enter password confirmation';
                  }
                  if(value != _passwordController.text) {
                    return 'Password do not match';
                  }
                  return null;
                },
                hintText: "Confirm password",
              ),
              RoundedInputField(
                controller: _phoneNumberController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                hintText: "Phone Number",
              ),
              RoundedButton(
                text: "SIGN UP",

                onPress: () async {
                  if (_formKey.currentState.validate()) {
                    User user = await _register();
                    if (user != null) {
                      segueToPage(context, PiggyBuyApp());
                    }
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
