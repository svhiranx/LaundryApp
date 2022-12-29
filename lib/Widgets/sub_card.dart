import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundryappv2/Models/plans.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:flutter/material.dart';

import 'confirmpackage.dart';

class SubCard extends StatelessWidget {
  SubCard(
      {super.key,
      required this.isValidSub,
      required this.snapshot,
      required this.index});
  QuerySnapshot snapshot;
  int index;
  bool isValidSub;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SizedBox(
        height: screenWidth * 0.4,
        width: screenWidth,
        child: Stack(
          children: [
            Container(
              height: screenWidth * 0.4,
              color: isValidSub ? Colors.grey.shade200 : Colors.blue.shade200,
            ),
            ClipPath(
              clipper: ProsteBezierCurve(
                position: ClipPosition.bottom,
                list: [
                  BezierCurveSection(
                    start: Offset(screenWidth * 0.9, 10),
                    top: Offset(screenWidth * 0.27, screenWidth / 3),
                    end: Offset(screenWidth * 0.4, 70),
                  ),
                  BezierCurveSection(
                    start: Offset(screenWidth * 0.2, 0),
                    top: Offset(screenWidth * 0.608, 0),
                    end: Offset(screenWidth, 0),
                  ),
                ],
              ),
              child: Container(
                color: isValidSub ? Colors.grey.shade100 : Colors.blue.shade100,
              ),
            ),
            SizedBox(
              height: screenWidth * 0.4,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenWidth * 0.14,
                        bottom: screenWidth * 0.14,
                        left: screenWidth * 0.1,
                        right: screenWidth * 0.14),
                    child: SizedBox(
                      height: 150,
                      width: screenWidth * 0.25,
                      child: Text(
                        "\u{20B9}" +
                            snapshot.docs[index].get('price').toString(),
                        style: TextStyle(fontSize: screenWidth * 0.07),
                      ),
                    ),
                  ),
                  Text(
                    snapshot.docs[index].get('title') + '*',
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                isValidSub
                    ? null
                    : showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (_) {
                          return confirmpackage(Plan(
                              id: snapshot.docs[index].id,
                              title: snapshot.docs[index].get('title'),
                              price: snapshot.docs[index].get('price'),
                              months: snapshot.docs[index].get('months'),
                              clothespermonth:
                                  snapshot.docs[index].get('clothesPerMonth')));
                        });
              },
              child: Container(
                color: Colors.white.withOpacity(0),
                height: 150,
                width: double.infinity,
              ),
            )
          ],
        ),
      ),
    );
  }
}
