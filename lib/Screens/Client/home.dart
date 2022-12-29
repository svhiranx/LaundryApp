import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:laundryappv2/Screens/Client/cart_screen.dart';
import 'package:laundryappv2/Screens/Client/dashboard.dart';
import 'package:laundryappv2/Screens/Client/notification_screen.dart';
import 'package:laundryappv2/Screens/Client/plans_screen.dart';
import 'package:laundryappv2/Screens/Client/profile_and_previous_orders.dart';
import 'package:laundryappv2/Screens/first_screen_route.dart';
import 'package:laundryappv2/Screens/signup_page.dart';
import 'package:laundryappv2/Screens/toggle_signUp.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  final String title = 'Welcome';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> updateFcmToken() async {
    try {
      var fcmToken = await FirebaseMessaging.instance.getToken();
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('UserData');
      var doc = await collection
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      await collection.doc(doc.docs.first.id).update({'fcmToken': fcmToken});
    } catch (e) {
      print('fcm token exception ${e}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    updateFcmToken();
    FlutterNativeSplash.remove();
    super.initState();
  }

  static List<Widget> homepage = <Widget>[
    const DashBoard(),
    PlansScreen(),
    NotificationScreen(),
    const PreviousOrdersScreen(),
  ];

  Future<void> signOutff() async => await FirebaseAuth.instance.signOut();
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.email);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottomOpacity: 0,
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                signOutff();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const FirstScreenRoute()));
              },
              icon: const Icon(Icons.logout))
        ],
        title: SizedBox(
            height: 150,
            child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: homepage[_selectedIndex],

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavBarTap,
        backgroundColor: Colors.blue,
        items: [
          BottomNavyBarItem(
              icon: const Icon(Icons.home, color: Colors.white),
              title: const Text('Dashboard'),
              activeColor: Colors.white),

          BottomNavyBarItem(
              icon: const Icon(Icons.attach_money, color: Colors.white),
              title: const Text('Buy Package'),
              activeColor: Colors.white),

          BottomNavyBarItem(
              icon: const Icon(Icons.notifications, color: Colors.white),
              title: const Text('Notifications'),
              activeColor: Colors.white),
          BottomNavyBarItem(
              icon: const Icon(Icons.portrait, color: Colors.white),
              title: const Text('Your Profile'),
              activeColor: Colors.white),

          // BottomNavigationBarItem(
          //     icon: Icon(Icons.ac_unit),
          //     label: '',
          //     backgroundColor: Colors.deepPurple),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.ac_unit),
          //     label: '',
          //     backgroundColor: Colors.deepPurple),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.ac_unit),
          //     label: '',
          //     backgroundColor: Colors.deepPurple),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.ac_unit),
          //     label: '',
          //     backgroundColor: Colors.deepPurple),
        ],
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //   fixedColor: Colors.white,
      //   backgroundColor: Colors.white,
      //   currentIndex: _selectedIndex,
      //   onTap: _onNavBarTap,
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home, color: Colors.blue),
      //         label: '',
      //         backgroundColor: Colors.white),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.shopping_cart, color: Colors.blue),
      //         label: '',
      //         backgroundColor: Colors.white),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.attach_money, color: Colors.blue),
      //         label: '',
      //         backgroundColor: Colors.white),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.portrait, color: Colors.blue),
      //         label: '',
      //         backgroundColor: Colors.white),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.ac_unit),
      //         label: '',
      //         backgroundColor: Colors.deepPurple),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.ac_unit),
      //         label: '',
      //         backgroundColor: Colors.deepPurple),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.ac_unit),
      //         label: '',
      //         backgroundColor: Colors.deepPurple),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.ac_unit),
      //         label: '',
      //         backgroundColor: Colors.deepPurple),
      //   ],
      // ),
    );
  }
}
