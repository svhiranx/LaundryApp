import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:laundryappv2/Screens/Client/home.dart';
import 'package:laundryappv2/Screens/Client/plans_screen.dart';
import 'package:laundryappv2/Screens/signup_page.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:provider/provider.dart';

class CheckAndRedirect extends StatefulWidget {
  const CheckAndRedirect({super.key});

  @override
  State<CheckAndRedirect> createState() => _CheckAndRedirectState();
}

class _CheckAndRedirectState extends State<CheckAndRedirect> {
  var isNew;
  Future<void> isNewUser() async {
    var subscriptionData = await FirebaseFirestore.instance
        .collection("Subscriptions")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (subscriptionData.docs.isNotEmpty) {
      isNew = false;
      print(isNew);
    } else {
      isNew = true;
      print(isNew);
    }
  }

  bool isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        isLoading = true;
      });

      await isNewUser();

      setState(() {
        isLoading = false;
      });
    });

    print('isNewUser checked');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading || isNew == null
        ? const Scaffold(body: CustomLoading())
        : isNew
            ? PlansScreen(mode: 'screen')
            : const Home();
  }
}
