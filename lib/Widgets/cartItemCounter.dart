import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/cart.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:provider/provider.dart';

class CartItemCounter extends StatefulWidget {
  CartItemCounter({super.key, required this.itemTitle});
  String itemTitle;
  @override
  State<CartItemCounter> createState() => _CartItemCounterState();
}

class _CartItemCounterState extends State<CartItemCounter> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var cart = Provider.of<Cart>(context, listen: true);
    var subdata = Provider.of<SubscriptionData>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: height * 0.075),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.2, top: height * 0.03),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  cart.removeItem(widget.itemTitle);
                }),
                child: CircleAvatar(
                  radius: height * 0.015,
                  backgroundColor: Color.fromARGB(201, 233, 234, 239),
                  child: Icon(
                    Icons.remove,
                    size: height * 0.015,
                  ),
                ),
              ),
              Container(
                width: width * 0.08,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "  " +
                        '${cart.itemCount(widget.itemTitle)}'.toString() +
                        "  ",
                    style: TextStyle(fontSize: width * 0.033),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  if (subdata.balance - cart.totalCount() > 0)
                    cart.addItem(widget.itemTitle);
                  else {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text('You\'ve hit your monthly count limit')));
                  }
                }),
                child: CircleAvatar(
                  radius: height * 0.015,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.add,
                    size: height * 0.015,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// Color.fromARGB(255, 52, 62, 113),