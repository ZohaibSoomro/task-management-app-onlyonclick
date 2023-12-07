import 'package:flutter/material.dart';

class RectengularRoundedButton extends StatelessWidget {
  final Color color;
  final String buttonName;
  final double? fontSize;
  final void Function() onPressed;
  const RectengularRoundedButton(
      {super.key,
      required this.color,
      required this.buttonName,
      this.fontSize = 18,
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
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
