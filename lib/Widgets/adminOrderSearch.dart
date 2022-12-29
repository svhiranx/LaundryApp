import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:laundryappv2/Widgets/order_cards.dart';
import 'package:provider/provider.dart';

class OrderSearch extends StatefulWidget {
  BuildContext parentContext;
  String mode;
  OrderSearch({super.key, required this.parentContext, required this.mode});

  @override
  State<OrderSearch> createState() => _OrderSearchState();
}

class _OrderSearchState extends State<OrderSearch> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.mode.contains('verify')
          ? FirebaseFirestore.instance
              .collection('Orders')
              .where('Email',
                  isGreaterThanOrEqualTo:
                      Provider.of<Orders>(context, listen: true).searchString)
              .where('Email',
                  isLessThanOrEqualTo:
                      "${Provider.of<Orders>(context, listen: true).searchString}z")
              .where('isVerified', isEqualTo: false)
              .where('hasError', isEqualTo: false)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Orders')
              .where('Email',
                  isGreaterThanOrEqualTo:
                      Provider.of<Orders>(context, listen: true).searchString)
              .where('Email',
                  isLessThanOrEqualTo:
                      "${Provider.of<Orders>(context, listen: true).searchString}z")
              .where('isVerified', isEqualTo: true)
              .where('isDelivered', isEqualTo: false)
              .where('hasError', isEqualTo: false)
              .snapshots(),
      builder: ((context, list) {
        print(Provider.of<Orders>(context, listen: true).searchString);
        if (list.hasError)
          return const Center(child: Text('Something went wrong.'));
        else if (list.connectionState == ConnectionState.waiting) {
          return const CustomLoading();
        } else if (!list.hasData) {
          return const Center(child: Text('No records found stream.'));
        } else {
          return FutureBuilder(
              future: Provider.of<Orders>(context).convertsnapshot(list),
              builder: (context, list) {
                if (list.connectionState == ConnectionState.waiting)
                  return const CustomLoading();
                else if (!list.hasData) {
                  return const Center(
                    child: Text('No records found!  '),
                  );
                } else if (list.hasData) {
                  print('future built');
                  return ListView.builder(
                      itemCount: list.data!.length,
                      itemBuilder: (context, count) {
                        return OrderCards(
                            parentContext: widget.parentContext,
                            id: list.data![count].id,
                            mail: list.data![count].mail,
                            type: widget.mode,
                            totalcloth: list.data![count].totalCloth,
                            map: list.data![count].clothes,
                            orderdate: DateFormat.yMMMd()
                                .format(list.data![count].dateTime));
                      });
                } else {
                  return const Center(child: Text('No records found!'));
                }
              });
        }
      }),
    );
  }
}
