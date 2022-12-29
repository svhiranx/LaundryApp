import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:laundryappv2/Models/auth.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var _isLoading = false;

  Future<void> signupff(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print('Error at sign up' + e.toString());
    }
  }

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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

    Future<DocumentReference> addUserDatatoDB(
        String name, String email, String userId, String token) {
      Auth item = Auth.construct(name, email, userId, token);
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('UserData');
      return collection.add(item.toJson());
    }

    Future<void> _submit(String email, String pwd) async {
      try {
        setState(() {
          _isLoading = true;
          print('object');
        });

        await signupff(
          email,
          pwd,
        );
        var token = await FirebaseMessaging.instance.getToken();
        await addUserDatatoDB(nameController.text, email,
            FirebaseAuth.instance.currentUser!.uid, token!);
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

        _showErrorDialog(errorMessage);
        setState(() {
          _isLoading = false;
          print('sidasdjfioajn');
        });
      }
      // } catch (error) {
      //   print('stupidfucjubngerror' + error.toString());
      //   const errorMessage =
      //       'Could not authenticate you. Please try again later.';
      //   _showErrorDialog(errorMessage);
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(padding * 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'SPINNERS',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(height * 0.01),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          padding: EdgeInsets.all(height * 0.01),
                          child: TextFormField(
                            //obscureText: true,
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value1) {
                              if (value1 == null || value1.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(height * 0.01),
                          child: TextFormField(
                            //  obscureText: true,
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Email';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Check your mail';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(height * 0.01),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Password.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(height * 0.01),
                          child: TextFormField(
                            obscureText: true,
                            controller: confirmpasswordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Password.';
                              } else if (confirmpasswordController.text !=
                                  passwordController.text) {
                                return 'Enter same password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.resolveWith(
                                  (states) {
                                    // If the button is pressed, return size 40, otherwise 20

                                    return const Size.fromWidth(100);
                                  },
                                ),
                              ),
                              child: const Text('Sign Up'),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                _submit(emailController.text,
                                    passwordController.text);

                                //_submit(nameController.text, passwordController.text);
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Already have account?'),
                            TextButton(
                              onPressed: () {
                                Provider.of<Auth>(context, listen: false)
                                    .toggleSignUp();
                              },
                              child: const Text(
                                'Login ',
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ],
            ),
    );
  }
}
