import 'package:flutter/material.dart';

class PositiveButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onPressed;
  final ButtonShapeType? buttonShapeType;
  const PositiveButton({Key? key, this.title, required this.onPressed, this.buttonShapeType = ButtonShapeType.medium}) : super(key: key);

  @override
  _PositiveButtonState createState() => _PositiveButtonState();
}

class _PositiveButtonState extends State<PositiveButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // style: ButtonStyle(
      //   padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 4)),
      // ),
      style: ElevatedButton.styleFrom(
          primary: Color(0xff3A67B1),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          minimumSize: Size(350, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.buttonShapeType == ButtonShapeType.medium ? 12 : 8),),),
      onPressed: widget.onPressed,
      child: Text(
        widget.title ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

class NegativeButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onPressed;
  final ButtonShapeType? buttonShapeType;

  const NegativeButton({Key? key, this.title, required this.onPressed, this.buttonShapeType = ButtonShapeType.medium}) : super(key: key);

  @override
  _NegativeButtonState createState() => _NegativeButtonState();
}

class _NegativeButtonState extends State<NegativeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // style: ButtonStyle(
      //   padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 4)),
      // ),
      style: ElevatedButton.styleFrom(
          primary: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          minimumSize: Size(350, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.buttonShapeType == ButtonShapeType.medium ? 12 : 8))),
      onPressed: widget.onPressed,
      child: Text(
        widget.title ?? '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

enum ButtonShapeType {small, medium}