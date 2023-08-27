import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SharedMethod {
  void showToast(String message) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
