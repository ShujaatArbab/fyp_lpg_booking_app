import 'package:flutter/material.dart';
import 'package:lpg_booking_system/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  const CustomButton({super.key, required this.text, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onpressed,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
