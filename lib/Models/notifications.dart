import 'package:flutter/material.dart';

class NotificationModel {
  Map<String, CircleAvatar> map = const {
    "Verified": CircleAvatar(
      foregroundColor: Colors.blue,
      backgroundColor: Color.fromARGB(183, 255, 255, 255),
      child: Icon(Icons.check),
    ),
    "Error": CircleAvatar(
      foregroundColor: Color.fromARGB(255, 246, 21, 21),
      backgroundColor: Color.fromARGB(183, 255, 255, 255),
      child: Icon(Icons.close),
    ),
    "Delivered": CircleAvatar(
      foregroundColor: Color.fromARGB(255, 255, 255, 255),
      backgroundColor: Color.fromARGB(183, 43, 138, 255),
      child: Icon(Icons.check),
    ),
  };

  static timediferrence(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays >= 365) {
      return "${(diff.inDays / 365).round()} yrs";
    } else if (diff.inDays >= 31) {
      return "${(diff.inDays / 7).round()} W";
    } else if (diff.inHours >= 24) {
      return "${(diff.inDays).round()} D";
    } else if (diff.inMinutes >= 60) {
      return "${(diff.inHours).round()} H";
    } else if (diff.inSeconds >= 60) {
      return "${(diff.inMinutes).round()} m";
    } else if (diff.inSeconds < 60) {
      return "${(diff.inSeconds).round()} s";
    } else
      return "Error";
  }
}
