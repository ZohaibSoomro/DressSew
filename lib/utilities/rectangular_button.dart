import 'package:dresssew/utilities/constants.dart';
import 'package:flutter/material.dart';

class RectangularRoundedButton extends StatelessWidget {
  Color color;
  String buttonName;
  double? fontSize;
  final EdgeInsets padding;
  void Function()? onPressed;
  RectangularRoundedButton({
    this.color = Colors.blue,
    required this.buttonName,
    this.fontSize = 18,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          buttonName,
          style: kTextStyle.copyWith(fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }
}
