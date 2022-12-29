import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.height * 0.01;

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An Error Occurred!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    Future<void> login(String email, String password) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        print(credential.user!.uid.toString());
      } on FirebaseAuthException catch (e) {
        rethrow;
      }
    }

    Future<void> _submit(String email, String pwd) async {
      try {
        setState(() {
          _isLoading = true;
        });

        await login(
          email,
          pwd,
        );
      } on FirebaseAuthException catch (e) {
        var errorMessage = 'Authentication failed';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        }

        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(errorMessage);
      } catch (error) {
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(padding * 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(padding),
                  child: const Text(
                    'SPINNERS',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(padding),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: EdgeInsets.all(padding),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: const ButtonStyle(),
                          child: const Text('Login'),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _submit(
                                nameController.text, passwordController.text);

                            //_submit(nameController.text, passwordController.text);
                          },
                        )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Sign up Instead?'),
                  TextButton(
                    child: const Text(
                      'Sign up Here',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      //signup screen
                      Provider.of<Auth>(context, listen: false).toggleSignUp();
                    },
                  )
                ],
              ),
            ],
          )),
    );
  }
}
