import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/plans.dart';
import 'package:laundryappv2/Widgets/areyousurebox.dart';
import 'package:provider/provider.dart';

import '../Models/subscriptions.dart';

class confirmpackage extends StatelessWidget {
  final Plan chosenPlan;

  confirmpackage(this.chosenPlan);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print(width);
    return Container(
      height: height * 0.25,
      width: width * 0.7,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Spacer(),
        Text(
          chosenPlan.title!,
          style:
              TextStyle(fontSize: height * 0.03, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: height * 0.017,
        ),
        Text(
          "COUNT PER MONTH-" + " " + chosenPlan.clothespermonth.toString(),
          style:
              TextStyle(fontSize: height * 0.02, fontWeight: FontWeight.bold),
        ),
        Text(
          "COST :  " + "\u{20B9}" + chosenPlan.price.toString(),
          style:
              TextStyle(fontSize: height * 0.02, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: height * 0.017,
        ),
        AreYouSure(chosenPlan: chosenPlan),
        Spacer(),
      ]),
    );
  }
}

            // child: ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       shape: (RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(width * 0.05),
            //       )),
            //       primary: Colors.green,
            //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //       textStyle: TextStyle(
            //           fontSize: height * 0.9, fontWeight: FontWeight.bold)),
            //   onPressed: () =>
            //       Provider.of<SubscriptionData>(context, listen: false)
            //           .subscribe(Subscription(
            //               subscriptionId: id,
            //               subcriptionDate: DateTime.now(),
            //               validity: months,
            //               clothCount: cloths)),
            //   child: Text("CONTINUE PAYMENT",
            //       style: TextStyle(fontSize: height * 0.024)),
            // ),