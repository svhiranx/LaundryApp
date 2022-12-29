import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/plans.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:laundryappv2/Screens/Client/home.dart';
import 'package:provider/provider.dart';

class AreYouSure extends StatefulWidget {
  AreYouSure({Key? key, required this.chosenPlan}) : super(key: key);
  Plan chosenPlan;
  @override
  State<AreYouSure> createState() => _AreYouSureState();
}

class _AreYouSureState extends State<AreYouSure> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: (RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.05),
          )),
          primary: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle:
              TextStyle(fontSize: height * 0.9, fontWeight: FontWeight.bold)),
      onPressed: (() {
        openAlertBox();
      }),
      child:
          Text("CONTINUE PAYMENT", style: TextStyle(fontSize: height * 0.024)),
    );
  }

  openAlertBox() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Are you sure you want to purchase this subscription?',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: (() async {
                //   await Provider.of<Plan>(context)
                //      .addSubscriptiontoDB;
                await Provider.of<SubscriptionData>(context, listen: false)
                    .subscribe(widget.chosenPlan)
                    .then((value) => Navigator.of(context).pushAndRemoveUntil(
                          _slidinganimation(),
                          (route) => false,
                        ));
              }),
              child: Text('Yes')),
          TextButton(
              onPressed: (() => Navigator.of(context).pop()), child: Text('No'))
        ],
      ),
    );
  }
}

Route _slidinganimation() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ThankYouPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.decelerate;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ThankYouPage extends StatefulWidget {
  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

Color themeColor = const Color(0xFF43D19E);

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: Height * 0.3,
              child: Image.network(
                "https://media.giphy.com/media/YlSR3n9yZrxfgVzagm/giphy.gif",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Height * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: Height * 0.01),
            const Text(
              "Payment done Successfully",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: Height * 0.08),
            const Text(
              "Click here to return to home",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 75, 64, 64),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: Height * 0.01),
            GestureDetector(
              onTap: (() async {
                await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                  (route) => false,
                );
              }),
              child: Container(
                height: Height * 0.07,
                width: Width * 0.6,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Height * 0.03,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
