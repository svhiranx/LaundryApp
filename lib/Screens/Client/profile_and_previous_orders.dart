import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryappv2/Models/auth.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:laundryappv2/Widgets/new_order_card_user.dart';
import 'package:laundryappv2/Widgets/order_cards.dart';
import 'package:laundryappv2/Widgets/previous_subscriptions.dart';
import 'package:laundryappv2/Widgets/sub_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:laundryappv2/Models/orders.dart';

import '../../Models/plans.dart';

class PreviousOrdersScreen extends StatefulWidget {
  const PreviousOrdersScreen({super.key});

  @override
  State<PreviousOrdersScreen> createState() => _PreviousOrdersScreenState();
}

class _PreviousOrdersScreenState extends State<PreviousOrdersScreen> {
  bool _isLoading = false;
  bool _isInit = false;
  // Future<void> getOrders() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     print(error);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // getOrders();
    super.initState();
  }

  Widget build(BuildContext context) {
    final orderProvider = Provider.of<Orders>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            margin: EdgeInsets.all(width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Mail ID: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Previous Subscriptions: ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(fit: FlexFit.tight, flex: 9, child: OldPacks()),
        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.02),
              child: Text(
                'Previous Orders',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 21,
          child: FutureBuilder(
            future: orderProvider.fetchOrdersUser(),
            builder: ((context, AsyncSnapshot<List<OrderItem>> itemList) {
              if (itemList.connectionState == ConnectionState.waiting) {
                return const CustomLoading();
              } else if (itemList.hasError) {
                return const Text('error');
              } else if (itemList.data!.isEmpty) {
                return const Center(child: Text('No Orders yet.'));
              } else {
                return ListView.builder(
                  itemCount: itemList.data!.length,
                  itemBuilder: (context, count) {
                    return NewOrderCardUser(
                        deliveryDate: itemList.data![count].deliveryDate,
                        hasError: itemList.data![count].hasError,
                        isDispatched: itemList.data![count].isDelivered,
                        isVerified: itemList.data![count].isVerified,
                        totalcloth: itemList.data![count].totalCloth,
                        map: itemList.data![count].clothes,
                        orderdate: DateFormat.yMMMd()
                            .format(itemList.data![count].dateTime));
                  },
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:laundryappv2/Models/auth.dart';
// import 'package:laundryappv2/Widgets/customLoading.dart';
// import 'package:laundryappv2/Widgets/new_order_card_user.dart';
// import 'package:laundryappv2/Widgets/order_cards.dart';
// import 'package:laundryappv2/Widgets/previous_subscriptions.dart';
// import 'package:laundryappv2/Widgets/sub_card.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:laundryappv2/Models/orders.dart';

// import '../../Models/plans.dart';

// class PreviousOrdersScreen extends StatefulWidget {
//   const PreviousOrdersScreen({super.key});

//   @override
//   State<PreviousOrdersScreen> createState() => _PreviousOrdersScreenState();
// }

// class _PreviousOrdersScreenState extends State<PreviousOrdersScreen> {
//   bool _isLoading = false;
//   bool _isInit = false;
//   // Future<void> getOrders() async {
//   //   try {
//   //     setState(() {
//   //       _isLoading = true;
//   //     });
//   //     await Provider.of<Orders>(context, listen: false).fetchOrders();
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   } catch (error) {
//   //     print(error);
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     // getOrders();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<Orders>(context, listen: false);
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Column(
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(10),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Your Profile',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         Flexible(
//           flex: 1,
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.all(width * 0.05),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Text(
//                           'Mail ID: ',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           FirebaseAuth.instance.currentUser!.email.toString(),
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           'Previous Subscriptions: ',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     FutureBuilder(
//                       future: Provider.of<Plan>(context).fetchPlans(),
//                       builder:
//                           ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Padding(
//                               padding: EdgeInsets.only(top: height * 0.06),
//                               child: const CircularProgressIndicator());
//                         } else if (snapshot.hasError) {
//                           return const Text('error');
//                         } else if (!snapshot.hasData) {
//                           return const Text('Emptwy :(');
//                         } else {
//                           return OldPacks();
//                         }
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const Padding(
//           padding: EdgeInsets.all(10),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Previous Orders',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         Flexible(
//           flex: 1,
//           child: FutureBuilder(
//             future: orderProvider.fetchOrdersUser(),
//             builder: ((context, AsyncSnapshot<List<OrderItem>> itemList) {
//               if (itemList.connectionState == ConnectionState.waiting) {
//                 return const CustomLoading();
//               } else if (itemList.hasError) {
//                 return const Text('error');
//               } else if (itemList.data!.isEmpty) {
//                 return const Center(child: Text('No Orders yet.'));
//               } else {
//                 return ListView.builder(
//                   itemCount: itemList.data!.length,
                  // itemBuilder: (context, count) {
                  //   return NewOrderCardUser(
                  //       deliveryDate: itemList.data![count].deliveryDate,
                  //       hasError: itemList.data![count].hasError,
                  //       isDispatched: itemList.data![count].isDelivered,
                  //       isVerified: itemList.data![count].isVerified,
                  //       totalcloth: itemList.data![count].totalCloth,
                  //       map: itemList.data![count].clothes,
                  //       orderdate: DateFormat.yMMMd()
                  //           .format(itemList.data![count].dateTime));
                  // },
//                 );
//               }
//             }),
//           ),
//         ),
//       ],
//     );
//   }
// }



        