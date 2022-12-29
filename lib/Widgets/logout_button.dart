import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:laundryappv2/Screens/first_screen_route.dart';
import 'package:laundryappv2/Screens/Client/plans_screen.dart';
import '../Screens/signup_page.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  Future<void> signOutff() async => await FirebaseAuth.instance.signOut();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        child: Icon(Icons.more_vert_outlined),
        itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text(' Logout',
                    style: TextStyle(color: Colors.black)),
                value: 1,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlansScreen(),
                  ));
                  // signOutff();

                  // getTokenAndSubscribe();
                },
              )
            ]);
  }
}
