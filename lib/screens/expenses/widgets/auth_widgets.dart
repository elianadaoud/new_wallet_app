import 'package:flutter/material.dart';

Image logoWidget(String logoPath) {
  return Image.asset(
    logoPath,
    fit: BoxFit.fitWidth,
    height: 240,
    width: 240,
  );
}

TextFormField reusableTextField(
    {required String text,
    required IconData icon,
    required bool isPassword,
    GlobalKey<FormState>? key,
    required TextEditingController controller}) {
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
        prefixIcon: Icon(icon),
        labelText: text,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container authButton(
    {required BuildContext context,
    required String type,
    required Function onClicked}) {
  return Container(
    width: MediaQuery.sizeOf(context).width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onClicked();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        type,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
