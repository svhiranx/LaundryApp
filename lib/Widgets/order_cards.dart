import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/main.dart';
import 'package:http/http.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Widgets/customDialog.dart';
import 'package:provider/provider.dart';

class OrderCards extends StatelessWidget {
  BuildContext? parentContext;
  String? id;
  String? mail;
  String type;
  int totalcloth;
  Map<String, int> map;
  String orderdate;
  OrderCards(
      {this.parentContext,
      this.id,
      this.mail,
      required this.type,
      required this.orderdate,
      required this.totalcloth,
      required this.map});
  bool expandinfo = false;

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<Orders>(context);

    Future<void> notifyAndUpdate(String mode) async {
      try {
        if (mode.contains('verify')) {
          String title = 'Order Verified!';
          String body =
              'Your order has been verified and will soon be processed.';
          await orderProvider.sendNotification(mail!, body, title);
        }
        if (mode.contains('reject')) {
          String title = 'Order Rejected!';
          String body =
              'Your order has been rejected, please order again with an accurate count.';
          await orderProvider.sendNotification(mail!, body, title);
        } else if (mode.contains('deliver')) {
          String title = 'Order Completed!';
          String body =
              'Your clothes have been washed, please collect them as soon as possible.';
          await orderProvider.sendNotification(mail!, body, title);
        }

        await orderProvider.updateOrder(mail!, id!, mode);
        showDialog(
            context: parentContext!,
            builder: ((parentContext) => CustomDialog(
                title: 'Successfully Notified!',
                message:
                    'User has been notified and records have been updated')));
      } catch (e) {
        showDialog(
            context: parentContext!,
            builder: ((parentContext) => CustomDialog(
                title: 'Error Occured!', message: 'Something went wrong')));
      }
    }

    var height = MediaQuery.of(context).size.height;
    var widgth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.blue.shade50,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                  top: height * 0.015, left: height * 0.025, bottom: 3),
              child: Text(
                mail!,
                style: TextStyle(
                    fontSize: height * 0.023, fontWeight: FontWeight.bold),
              )),
          ExpansionTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: EdgeInsets.only(
                        top: height * 0.001, bottom: height * 0.015),
                    child: Text(
                      "Count : " + totalcloth.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                    padding: EdgeInsets.only(
                        top: height * 0.001, bottom: height * 0.015),
                    child: Text(
                      "Ordered on : " + orderdate.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            subtitle: Container(
              padding: EdgeInsets.only(bottom: height * 0.01),
            ),
            children: [
              Column(
                children: [
                  Container(
                    child: Column(children: [
                      for (var i = 0; i < map.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: SizedBox(
                            width: widgth * 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  map.keys.elementAt(i),
                                  style: TextStyle(fontSize: height * 0.023),
                                ),
                                Text(
                                    " x " + map.values.elementAt(i).toString()),
                              ],
                            ),
                          ),
                        )
                    ]),
                  ),
                  type.contains('verify')
                      ? Padding(
                          padding: EdgeInsets.all(widgth * 0.03),
                          child: Wrap(
                            spacing: widgth * 0.2,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    await notifyAndUpdate('verify');
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue)),
                                  child: const Text('Accept')),
                              ElevatedButton(
                                  onPressed: () async {
                                    await notifyAndUpdate('reject');
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  child: const Text('Reject'))
                            ],
                          ),
                        )
                      : type.contains('deliver')
                          ? Padding(
                              padding: EdgeInsets.all(widgth * 0.03),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await notifyAndUpdate('deliver');
                                  },
                                  child: const Text('Deliver')),
                            )
                          : Container()
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
