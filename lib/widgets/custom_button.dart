import 'package:flutter/material.dart';
import 'package:saaligram/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.onPressed, required this.child})
      : super(key: key);
  final VoidCallback onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        elevation: 5,
        minimumSize: const Size(130, 50),
        primary: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
