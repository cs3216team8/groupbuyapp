import "package:flutter/material.dart";

class RoundedInputField extends StatelessWidget {
  final FormFieldValidator<String> validator;
  final IconData icon;
  final TextEditingController controller;
  final String hintText;

  final Color iconColor, color;

  const RoundedInputField({
    Key key,
    this.controller,
    this.validator,
    this.hintText,
    this.icon = Icons.person,
    this.iconColor = Colors.white,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: color,
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.3),
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            fillColor: Theme.of(context).accentColor.withAlpha(60),
            filled: true,
            hintText: hintText,
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Color(0x00000000), width: 0.0),
            ),
            focusedBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
            ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),

        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final String hintText;

  final Color formFieldColor, color, iconColor;

  const RoundedPasswordField({
    Key key,
    this.controller,
    this.validator,
    this.hintText = "Password",
    this.formFieldColor,
    this.color,
    this.iconColor,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      color: widget.color,
      child: TextFormField(
        obscureText: !_showPassword,
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
          fillColor: Theme.of(context).accentColor.withAlpha(60),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: widget.iconColor,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Color(0x00000000), width: 0.0),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  const TextFieldContainer({
    Key key,
    this.child,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
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
