import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:laundryappv2/Screens/Admin/admin_all_orders_screen.dart';
import 'package:laundryappv2/Screens/Admin/admin_home.dart';
import 'package:laundryappv2/Screens/check_and_redirect.dart';
import 'package:laundryappv2/Screens/Client/home.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';

class CheckIfAdmin extends StatefulWidget {
  @override
  State<CheckIfAdmin> createState() => _CheckIfAdminState();
}

class _CheckIfAdminState extends State<CheckIfAdmin> {
  var isAdmin;
  checkAdminState() async {
    var authData = await FirebaseFirestore.instance
        .collection("UserData")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    try {
      isAdmin = authData.docs.first.get('isAdmin');
    } on StateError {
      isAdmin = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    try {
      Future.delayed(Duration.zero).then((_) async {
        await checkAdminState();
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('isAdminCheck');
    return isAdmin == null
        ? const Scaffold(body: CustomLoading())
        : isAdmin
            ? const AdminHome()
            : const CheckAndRedirect();
  }
}
