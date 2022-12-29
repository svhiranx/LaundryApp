import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryappv2/Models/notifications.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard({super.key, required this.date, required this.mode});
  DateTime date;
  String mode;
  late String status;

  Widget build(BuildContext context) {
    NotificationModel object = NotificationModel();
    var height = MediaQuery.of(context).size.height;
    mode.contains('verify')
        ? status = 'Verified'
        : mode.contains("reject")
            ? status = 'Rejected'
            : mode.contains("deliver")
                ? status = 'Delivered'
                : status = "";
    return ListTile(
      title: Text("Your Order has been " + status + ".",
          style: TextStyle(fontSize: height * 0.019, color: Colors.black)),
      leading: object.map[status],
      trailing: Text(NotificationModel.timediferrence(date) + ' ago'),
    );
  }
}
