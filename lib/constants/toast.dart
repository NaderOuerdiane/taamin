import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}
