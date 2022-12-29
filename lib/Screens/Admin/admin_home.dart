import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:laundryappv2/Screens/Admin/add_product_screen.dart';
import 'package:laundryappv2/Screens/Admin/add_plans.dart';
import 'package:laundryappv2/Screens/Admin/admin_all_orders_screen.dart';
import 'package:laundryappv2/Screens/Admin/admin_orders_to_deliver.dart';
import 'package:laundryappv2/Screens/first_screen_route.dart';
import 'package:laundryappv2/Screens/signup_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  final String title = 'Welcome';
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    FlutterNativeSplash.remove();
    super.initState();
  }

  static List<Widget> homepage = <Widget>[
    VerifyOrders(),
    ViewVerifiedOrdersScreen(),
    AddProductScreen(),
    AddPlansScreen(),
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
                    builder: (context) => FirstScreenRoute()));
              },
              icon: Icon(Icons.logout))
        ],
        title: SizedBox(
            height: 150,
            child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
        // Text('SPINNER',
        //     style: TextStyle(
        //         color: Colors.blue,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 30)),
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
              icon: Icon(Icons.home, color: Colors.white),
              title: Text('Verify Order'),
              activeColor: Colors.white),
          BottomNavyBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              title: Text('Delivery'),
              activeColor: Colors.white),
          BottomNavyBarItem(
              icon: Icon(Icons.attach_money, color: Colors.white),
              title: Text('Add Product'),
              activeColor: Colors.white),
          BottomNavyBarItem(
              icon: Icon(Icons.portrait, color: Colors.white),
              title: Text('Add Plan'),
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
