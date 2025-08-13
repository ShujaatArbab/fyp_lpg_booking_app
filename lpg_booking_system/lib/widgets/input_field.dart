import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String errorText;
  final String hintText;
  final Widget? suffixicon;

  const TextInputField({
    super.key,
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.labelText,
    required this.errorText,
    required this.hintText,
    this.suffixicon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorText: errorText.isEmpty ? null : errorText,
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixicon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.orange, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.orange, width: 3),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
