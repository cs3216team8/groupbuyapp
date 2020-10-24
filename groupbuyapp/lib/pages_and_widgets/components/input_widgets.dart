import "package:flutter/material.dart";

class RoundedInputField extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;

  const RoundedInputField({
    Key key,
    this.controller,
    this.validator,
    this.hintText,
    this.icon = Icons.person,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            border: InputBorder.none
        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final String hintText;
  const RoundedPasswordField({
    Key key,
    this.controller,
    this.validator,
    this.hintText = "Password"
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: !_showPassword,
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(height: 0),
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withAlpha(60),
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.onPress,
    this.color = Colors.black26,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: onPress,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
