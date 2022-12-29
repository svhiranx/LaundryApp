import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Widgets/adminOrderSearch.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:laundryappv2/Widgets/order_cards.dart';
import 'package:laundryappv2/main.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ViewVerifiedOrdersScreen extends StatefulWidget {
  const ViewVerifiedOrdersScreen({super.key});

  @override
  State<ViewVerifiedOrdersScreen> createState() =>
      ViewVerifiedOrdersScreenState();
}

var text;

class ViewVerifiedOrdersScreenState extends State<ViewVerifiedOrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = "";
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context, listen: false);
    TextEditingController searchController = new TextEditingController();

    return Column(
      children: [
        const Center(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Orders to Deliver',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        )),
        Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: const InputDecoration(icon: Icon(Icons.search)),
              controller: searchController,
              onChanged: (value) {
                Provider.of<Orders>(context, listen: false)
                    .setSearch(searchController.text);
              },
            )),
        Flexible(
            flex: 2,
            child: OrderSearch(
              parentContext: context,
              mode: 'deliver',
            )
            // child: FutureBuilder(
            //  future: orderProvider.fetchOrders('admin'),
            //   builder: ((context, AsyncSnapshot<List<OrderItem>> itemList) {
            //     if (itemList.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (itemList.hasError) {
            //       return Text('error');
            //     } else if (itemList.data == []) {
            //       return Text('Emptwy :(');
            //     } else {
            //       return ListView.builder(
            //         itemCount: itemList.data!.length,
            //         itemBuilder: (context, count) {
            //           return ListTile(
            //               leading: Text('${itemList.data![count].totalCloth}'),
            //               title: Text(
            //                   '${DateFormat.yMMMd().format(itemList.data![count].dateTime)}'),
            //               trailing: Wrap(
            //                 children: [
            //                   ElevatedButton(
            //                     child: Text('Verify'),
            //                     onPressed: () => null,
            //                   ),
            //                   Padding(padding: EdgeInsets.only(left: 4)),
            //                   ElevatedButton(
            //                     child: Text('Contact'),
            //                     onPressed: () =>
            //                         flutterLocalNotificationsPlugin.show(
            //                             0,
            //                             'title',
            //                             'body',
            //                             NotificationDetails(
            //                                 android: AndroidNotificationDetails(
            //                               channel.id,
            //                               channel.name,
            //                               channelDescription: channel.description,
            //                               importance: Importance.high,
            //                               color: Colors.blue,
            //                               playSound: true,
            //                               icon: '@mipmap/ic_launcher',
            //                             ))),
            //                   ),
            //                 ],
            //               ),
            //               subtitle: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   ...itemList.data![count].clothes.entries
            //                       .map((e) => Text("${e.key} x ${e.value}"))
            //                 ],
            //               ));
            //         },
            //       );
            //     }
            //   }),
            // ),
            ),
      ],
    );
  }
}
