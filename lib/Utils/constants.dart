import 'package:flutter/material.dart';
class Constant{
  static const primaryColor =  Color(0xFFFFBD73);
  static const primaryAssentColor =  Color(0xFF808080);
  static const primaryDarkColor =  Color(0xFF808080);
  static const errorColor =  Color(0xFF808080);
  static const String signIn = 'signin';
  static const Color themeColor = Color(0xFFFFBD73);


  static const kSendButtonTextStyle = TextStyle(
    color: Colors.lightBlueAccent,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  static const kMessageTextFieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    hintText: 'Type your message here...',
    border: InputBorder.none,
  );

  static const kMessageContainerDecoration = BoxDecoration(
    border: Border(
      top: BorderSide(color: Constant.primaryColor, width: 2.0),
      bottom: BorderSide(color: Constant.primaryColor, width: 2.0),
      left: BorderSide(color: Constant.primaryColor, width: 2.0),
      right: BorderSide(color: Constant.primaryColor, width: 2.0),
    ),
  );

}
