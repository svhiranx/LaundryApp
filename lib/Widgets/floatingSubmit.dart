import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:laundryappv2/Models/cart.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Screens/Client/home.dart';
import 'package:provider/provider.dart';

class FloatingSubmit extends StatefulWidget {
  const FloatingSubmit({super.key});

  @override
  State<FloatingSubmit> createState() => _FloatingSubmitState();
}

class _FloatingSubmitState extends State<FloatingSubmit> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return !isLoading
        ? Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  AnimatedOpacity(
                      opacity: (Provider.of<Cart>(context, listen: true)
                                  .items
                                  .length >
                              0)
                          ? 1.0
                          : 0.0,
                      duration: const Duration(milliseconds: 350),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        width: width * 0.5,
                        height: height * 0.09,
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.07,
                              width: width * 0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 52, 62, 113),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Map<String, int> cartItems =
                                      Provider.of<Cart>(context, listen: false)
                                          .items;
                                  if (cartItems.isEmpty) return;
                                  final order = Provider.of<Orders>(context,
                                      listen: false);
                                  await order.addOrder(cartItems);
                                  print('${order.orderList.length}');
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: ((context) => Home())),
                                    (route) => false,
                                  );
                                },
                                child: Text("Submit",
                                    style: TextStyle(fontSize: height * 0.026)),
                              ),
                            )
                          ],
                        ),
                      )),
                  const Spacer(),
                ],
              ),
            ],
          )
        : Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator()));
  }
}
