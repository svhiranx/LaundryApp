import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:laundryappv2/Models/plans.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:laundryappv2/Screens/first_screen_route.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:laundryappv2/Widgets/sub_card.dart';
import 'package:provider/provider.dart';

class PlansScreen extends StatefulWidget {
  PlansScreen({super.key, this.mode});
  String? mode;
  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

Future<void> signOutff() async => await FirebaseAuth.instance.signOut();

class _PlansScreenState extends State<PlansScreen> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.mode != null) FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function subscribe = Provider.of<SubscriptionData>(context).subscribe;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return widget.mode != null
        ? Scaffold(
            appBar: AppBar(title: const Text('Welcome'), actions: [
              IconButton(
                  onPressed: () {
                    signOutff();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const FirstScreenRoute()));
                  },
                  icon: const Icon(Icons.logout))
            ]),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Text(
                        'Purchase a subscription to continue',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                          future: Provider.of<Plan>(context).fetchPlans(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return const CustomLoading();
                            if (!snapshot.hasData) {
                              return const Center(child: Text(':('));
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data!.size,
                                  itemBuilder: (context, index) {
                                    return SubCard(
                                      isValidSub: false,
                                      snapshot: snapshot.data!,
                                      index: index,
                                    );
                                  });
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Text(
                      'Subscriptions',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future:
                            Provider.of<Plan>(context).fetchPlansAndCheckSub(),
                        builder: (context, dynamic snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return const CustomLoading();
                          if (!snapshot.hasData) {
                            return const Center(child: Text(':('));
                          } else {
                            bool isValidSub = snapshot.data[1] as bool;
                            QuerySnapshot snapshotData = snapshot.data[0];
                            return ListView.builder(
                                itemCount: snapshot.data[0]!.size,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SubCard(
                                        isValidSub: isValidSub,
                                        snapshot: snapshot.data[0],
                                        index: index,
                                      ),
                                      if (index == snapshot.data[0]!.size - 1 &&
                                          isValidSub)
                                        const Text(
                                            'You already have a valid subscription!'),
                                    ],
                                  );
                                });
                          }
                        }),
                  ),
                ],
              ),
            ],
          );
  }
}
