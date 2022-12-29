import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/cart.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:provider/provider.dart';

class CartBalance extends StatefulWidget {
  CartBalance({super.key});

  bool isLoading = false;
  int balance = 0;
  @override
  State<CartBalance> createState() => _CartBalanceState();
}

class _CartBalanceState extends State<CartBalance> {
  @override
  void initState() {
    var subdata = Provider.of<SubscriptionData>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subdata.fetchbalance();
    });

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var subdata = Provider.of<SubscriptionData>(context, listen: true);
    var cart = Provider.of<Cart>(context, listen: true);
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.all(height * 0.02),
              child: Text(
                subdata.isLoading
                    ? 'Balance: loading...'
                    : 'Balance: ${subdata.balance - cart.totalCount()}',
                style: TextStyle(
                    fontSize: height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 65, 45, 45)),
              )),
        ),
        subdata.cycles != 4
            ? Container()
            : Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: height * 0.02, bottom: height * 0.02),
                    child: Text(
                      'You are out of cycles! ${subdata.durationBeforeNextOrder} to go for the next one...',
                      style: TextStyle(
                          fontSize: height * 0.025,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 65, 45, 45)),
                    )),
              )
      ],
    );
  }
}
