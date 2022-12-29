import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Screens/check_if_admin.dart';
import 'package:laundryappv2/Screens/toggle_signUp.dart';

class FirstScreenRoute extends StatelessWidget {
  const FirstScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        print('auth fetched');
        if (snapshot.hasData) {
          return CheckIfAdmin();
        }
        return ToggleSignUp();
      },
    );
  }
}
