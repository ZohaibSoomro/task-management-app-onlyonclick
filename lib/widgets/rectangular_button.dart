import 'package:flutter/material.dart';
import 'package:task_management_app_onlyonclick/constants.dart';

class RectengularRoundedButton extends StatelessWidget {
  final Color color;
  final String buttonName;
  final double? fontSize;
  final double padding;
  final void Function() onPressed;
  const RectengularRoundedButton(
      {super.key,
      this.color = kPrimaryColor,
      required this.buttonName,
      this.fontSize = 18,
      this.padding = 18,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
