import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final IconData icon;
  final String text;

  const CustomTextField(
      {super.key, required this.controller, required this.isPassword, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null) {
          return "please enter a value";
        } else {
          return null;
        }
      },
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
          prefixIcon: Icon(icon), labelText: text, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
    );
  }
}

// TextFormField customTextField(
//     {required String text,
//     required IconData icon,
//     required bool isPassword,
//     GlobalKey<FormState>? key,
//     required TextEditingController controller}) {
//   return 
// }
