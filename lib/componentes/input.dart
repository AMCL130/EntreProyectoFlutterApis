import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  const InputComponent(
      {Key? key,
      required this.label,
      required this.controller,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.validator})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: validator,
    );
  }
}
