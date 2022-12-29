import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/cart.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Models/product.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:laundryappv2/Widgets/cartBalance.dart';
import 'package:laundryappv2/Widgets/cartItemCounter.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:laundryappv2/Widgets/floatingSubmit.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Column(
          children: [
            CartBalance(),
            Flexible(
              child: FutureBuilder(
                  future: Provider.of<Products>(context).fetchProducts(),
                  builder: (context, AsyncSnapshot<dynamic> qsnapshot) {
                    if (qsnapshot.connectionState == ConnectionState.waiting) {
                      return const CustomLoading();
                    }

                    if (!qsnapshot.hasData) {
                      return (const Text('No Products uwu :('));
                    } else {
                      QuerySnapshot snapshot = qsnapshot.data[0];
                      int monthlycycles = qsnapshot.data[1] as int;
                      String? timeBeforeNextCycle = qsnapshot.data[2];
                      return monthlycycles != 4
                          ? ListView.builder(
                              itemCount: snapshot.docs.length,
                              itemBuilder: (context, count) => Padding(
                                  padding: EdgeInsets.all(height * 0.003),
                                  child: Column(
                                    children: [
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: SizedBox(
                                          height: height * 0.13,
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    height * 0.015),
                                                child: SizedBox(
                                                  height: height * 0.1,
                                                  width: height * 0.1,
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                          placeholder:
                                                              kTransparentImage,
                                                          image: snapshot
                                                              .docs[count]
                                                              .get("imageUrl")),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    height * 0.01),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: height * 0.015),
                                                      child: SizedBox(
                                                        height: height * 0.03,
                                                        child: Text(
                                                          snapshot.docs[count]
                                                              .get("title"),
                                                          style: TextStyle(
                                                              fontSize: height *
                                                                  0.023,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  0,
                                                                  0,
                                                                  0)),
                                                        ),
                                                      ),
                                                    ),
                                                    CartItemCounter(
                                                        itemTitle: snapshot
                                                            .docs[count]
                                                            .get('title')
                                                            .toString())
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      count == snapshot.docs.length - 1
                                          ? SizedBox(
                                              height: height * 0.1,
                                            )
                                          : Container()
                                    ],
                                  )))
                          : Center(
                              child: Text(
                                  'You are out of cycles! Your next cycle will be in ${timeBeforeNextCycle}'));
                    }
                  }),
            ),
          ],
        ),
        const FloatingSubmit()
      ],
    );
  }
}
