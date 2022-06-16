import 'package:firebase/Widgets/responsive_ui.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   late String hint;
   late TextEditingController textEditingController;
   late TextInputType keyboardType;
   late bool obscureText;
   late IconData icon;
   late double _width;
   late double _pixelRatio;
   late bool large;
   late bool medium;

  CustomTextField({Key? key,required TextInputType keyboardType,
    required TextEditingController textEditingController, required IconData icon,
    required String hint, required bool obscureText}) : super(key: key);

  /*CustomTextField(
      {required this.hint,
        required this.textEditingController,
        required this.keyboardType,
        required this.icon,
        this.obscureText= false,
      }) ;*/

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large? 12 : (medium? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Colors.orange[200],
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange[200], size: 20),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
