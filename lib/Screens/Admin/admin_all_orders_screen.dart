import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Widgets/adminOrderSearch.dart';
import 'package:provider/provider.dart';

class VerifyOrders extends StatefulWidget {
  const VerifyOrders({super.key});

  @override
  State<VerifyOrders> createState() => VerifyOrdersState();
}

var text;

class VerifyOrdersState extends State<VerifyOrders> {
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
              'Orders to Verify',
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
            child: OrderSearch(parentContext: context, mode: 'verify')),
      ],
    );
  }
}
