import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void _register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //super.dispose();
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
                    return('Please enter your full name');
                  }
                  return null;
                },
                hintText: "Full Name",
              ),
              RoundedInputField(
                controller: _usernameController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return('Please enter your username');
                  }
                  return null;
                },
                hintText: "Username",
              ),
              RoundedInputField(
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
                  hintText: "Email"
              ),
              RoundedPasswordField(
                controller: _passwordController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              RoundedPasswordField(
                controller: _passwordConfirmController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter password confirmation';
                  }
                  if(value != _passwordController.text) {
                    return 'Not Match';
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
