import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryappv2/Models/orders.dart';

import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:laundryappv2/Screens/Client/cart_screen.dart';
import 'package:laundryappv2/Widgets/dashCardText.dart';
import 'package:laundryappv2/Widgets/new_order_card_user.dart';
import 'package:laundryappv2/Widgets/order_cards.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class CircularChart extends StatefulWidget {
  const CircularChart({super.key});

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  @override
  Widget build(BuildContext context) {
    var subData = Provider.of<SubscriptionData>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    bool update = false;
    final orderProvider = Provider.of<Orders>(context, listen: false);

    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(5)),
          FutureBuilder(
            future: subData.fetchSubscription(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(10)),
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Monthly Statistics',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 20.0,
                                animation: true,
                                percent: 0,
                                center: const Text(
                                  "loading..",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                backgroundColor: Colors.grey.shade100,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.blueAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: SizedBox(
                            height: height * 0.2,
                            width: height * 0.35,
                            child: const Center(
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballClipRotateMultiple,
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                    child: Text(
                  ':(',
                ));
              } else {
                var subscription = snapshot.data[0] as Subscription;
                double percent = snapshot.data[1] / subscription.clothCount!;
                return Center(
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(10)),
                      Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Monthly Statistics',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 70.0,
                                lineWidth: 20.0,
                                animation: true,
                                percent: percent,
                                center: Text(
                                  (percent * 100).floor().toString() + "% used",
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                backgroundColor: Colors.grey.shade100,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.blueAccent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: SizedBox(
                          height: height * 0.2,
                          width: height * 0.35,
                          child: Row(
                            children: [
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  DashCardText(
                                      boldText: (subscription.clothCount! -
                                              snapshot.data[1])
                                          .toString(),
                                      subtitle: "clothes remaining"),
                                  const Spacer(),
                                  DashCardText(
                                      boldText: snapshot.data[1].toString(),
                                      subtitle: "clothes washed"),
                                  const Spacer(),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  DashCardText(
                                      boldText: (4 - snapshot.data[2])
                                          .ceil()
                                          .toString(),
                                      subtitle: "cycles remaining"),
                                  const Spacer(),
                                  DashCardText(
                                      boldText: snapshot.data[2].toString(),
                                      subtitle: "cycles used"),
                                  const Spacer(),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          Container(
            child: Flexible(
              flex: 1,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Current Order',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: FutureBuilder(
                      future: orderProvider.fetchCurrentOrder(),
                      builder: ((context, AsyncSnapshot<OrderItem?> item) {
                        if (item.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (item.hasError) {
                          return const Text('error');
                        } else if (!item.hasData) {
                          return Stack(
                            children: [
                              const Center(
                                  child:
                                      Text('Tap the Cart to place an order!')),
                              Padding(
                                padding: EdgeInsets.all(width * 0.03),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton(
                                    child: const Icon(Icons.shopping_cart),
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                                appBar: AppBar(
                                                  bottomOpacity: 0,
                                                  elevation: 0,
                                                  backgroundColor: Colors.blue,
                                                  actions: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        icon: const Icon(
                                                            Icons.arrow_back))
                                                  ],
                                                  title: SizedBox(
                                                      height: 150,
                                                      child: Image.asset(
                                                          'assets/logo.png',
                                                          fit: BoxFit.cover)),
                                                  centerTitle: true,
                                                  automaticallyImplyLeading:
                                                      false,
                                                ),
                                                body: CartScreen()))),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              NewOrderCardUser(
                                  deliveryDate: item.data!.deliveryDate,
                                  orderdate: DateFormat.yMMMd()
                                      .format(item.data!.dateTime),
                                  totalcloth: item.data!.totalCloth,
                                  map: item.data!.clothes,
                                  hasError: item.data!.hasError,
                                  isVerified: item.data!.isVerified,
                                  isDispatched: item.data!.isDelivered),
                              // OrderCards(
                              //     type: 'user',
                              // orderdate: DateFormat.yMMMd()
                              //     .format(item.data!.dateTime),
                              //     totalcloth: item.data!.totalCloth,
                              //     map: item.data!.clothes),
                              item.data!.isDelivered
                                  ? Padding(
                                      padding: EdgeInsets.all(width * 0.03),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: FloatingActionButton(
                                            child:
                                                const Icon(Icons.shopping_cart),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Scaffold(
                                                              appBar: AppBar(
                                                                bottomOpacity:
                                                                    0,
                                                                elevation: 0,
                                                                backgroundColor:
                                                                    Colors.blue,
                                                                actions: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .arrow_back))
                                                                ],
                                                                title: SizedBox(
                                                                    height: 150,
                                                                    child: Image.asset(
                                                                        'assets/logo.png',
                                                                        fit: BoxFit
                                                                            .cover)),
                                                                centerTitle:
                                                                    true,
                                                                automaticallyImplyLeading:
                                                                    false,
                                                              ),
                                                              body:
                                                                  CartScreen())));
                                            }),
                                      ),
                                    )
                                  : Container()
                            ],
                          );
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
