import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/auth.dart';
import 'package:laundryappv2/Screens/login_page.dart';
import 'package:laundryappv2/Screens/signup_page.dart';
import 'package:provider/provider.dart';

class ToggleSignUp extends StatelessWidget {
  const ToggleSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.of<Auth>(context, listen: true).signUpMode
        ? SignUpPage()
        : LoginPage();
  }
}
