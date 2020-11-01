import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/components/input_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:flushbar/flushbar.dart';
import 'components/login_background.dart';
import 'components/login_signup_option_widget.dart';

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

  Future<UserCredential> _register() async {
    try {
      UserCredential userCredential = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      ));
      String userId = userCredential.user.uid;
      Profile userProfile = new Profile(
          userId,
          _fullNameController.text,
          _usernameController.text,
          "",
          _phoneNumberController.text,
          _emailController.text,
          [],
          [],
          null,
          0
      );
      try {
        await ProfileStorage.instance.createOrUpdateUserProfile(userProfile);
        return userCredential;
      } catch (e) {
        print(e);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorFlushbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorFlushbar('The account already exists for that email.');
      }
    } catch (e) {
      showErrorFlushbar(e.message);
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
    return Scaffold(
      appBar: backAppBar(
        context: context,
        title: "",
        color: Colors.white,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
              SizedBox(height: 10,),
              RoundedInputField(
                color: Color(0xFFFBE3E1),
                iconColor: Theme.of(context).primaryColor,
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
                color: Color(0xFFFBE3E1),
                iconColor: Theme.of(context).primaryColor,
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
                color: Color(0xFFFBE3E1),
                iconColor: Theme.of(context).primaryColor,
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
                color: Color(0xFFFBE3E1),
                iconColor: Theme.of(context).primaryColor,
                controller: _passwordController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return '\n\nPlease enter password';
                  }
                  return null;
                },
              ),
              RoundedPasswordField(
                color: Color(0xFFFBE3E1),
                iconColor: Theme.of(context).primaryColor,
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
                color: Color(0xFFFBE3E1),
                iconColor: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor,
                text: "SIGN UP",
                textStyle: TextStyle(color:Colors.white),
                onPress: () async {
                  if (_formKey.currentState.validate()) {
                    UserCredential userCredential = await _register();
                    if (userCredential != null) {
                      segueWithoutBack(context, PiggyBuyApp());
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              LoginOrSignupOption(
                textColor: Theme.of(context).primaryColor,
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
  static final Color dividerColor = Color(0xFFD9D9D9);
  final Color textColor;

  OrDivider({
    Key key,
    this.textColor,
  }) : super(key: key);

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
                color: textColor,
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
        color: dividerColor,
        height: 1.5,
      ),
    );
  }
}
