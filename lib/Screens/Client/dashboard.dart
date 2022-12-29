import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/orders.dart';

import 'package:laundryappv2/Widgets/circular_chart.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    //getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context, listen: false);

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Flexible(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
              ),
            ),
            const Spacer(
              flex: 4,
            )
          ],
        ),
        const CircularChart(),
      ],
    );
  }
}
          //   floatingActionButton: _selectedIndex == 0
          // ? FloatingActionButton(
          //     child: Icon(Icons.shopping_cart),
          //     onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => Scaffold(
          //             appBar: AppBar(
          //               bottomOpacity: 0,
          //               elevation: 0,
          //               backgroundColor: Colors.blue,
          //               actions: [
          //                 IconButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                     icon: Icon(Icons.arrow_back))
          //               ],
          //               title: SizedBox(
          //                   height: 150,
          //                   child: Image.asset('assets/logo.png',
          //                       fit: BoxFit.cover)),
          //               // Text('SPINNER',
          //               //     style: TextStyle(
          //               //         color: Colors.blue,
          //               //         fontWeight: FontWeight.bold,
          //               //         fontSize: 30)),
          //               centerTitle: true,
          //               automaticallyImplyLeading: false,
          //             ),
          //             body: CartScreen()))),
          //   )
          // : null,