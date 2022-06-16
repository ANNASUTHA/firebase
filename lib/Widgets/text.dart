import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String? text;
  const HeaderText({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text ?? '',
        style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }
}
