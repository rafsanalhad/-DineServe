import 'package:flutter/material.dart';
import 'constants.dart';
import 'widgets.dart';

class RoundedPasswordField extends StatelessWidget {
  const RoundedPasswordField({ Key? key, this.controller, this.hintText }) : super(key: key);
  final TextEditingController? controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        obscureText: true,
        cursorColor: kPrimaryColor,
         decoration: InputDecoration(
            icon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            hintText: hintText,
            hintStyle:  TextStyle(fontFamily: 'OpenSans'),
            suffixIcon: Icon(
              Icons.visibility,
              color: kPrimaryColor,
            ),
            border: InputBorder.none),
      ),
    );
  }
}