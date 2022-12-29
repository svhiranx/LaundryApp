import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class OldPackCard extends StatelessWidget {
  @override
  String title;
  String startingDate;
  String endingDate;
  OldPackCard(this.title, this.startingDate, this.endingDate);
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: width * 0.1,
              bottom: width * 0.08,
              left: width * 0.05,
              right: width * 0.08),
          child: Container(
            alignment: Alignment.centerRight,
            height: height * 0.3,
            width: width * 0.35,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: height * 0.038,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 10,
              ),
              Text(
                startingDate,
                style: TextStyle(
                    fontSize: height * 0.02, fontWeight: FontWeight.bold),
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                "To",
                style: TextStyle(
                    fontSize: height * 0.02, fontWeight: FontWeight.bold),
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                endingDate,
                style: TextStyle(
                    fontSize: height * 0.02, fontWeight: FontWeight.bold),
              ),
              Spacer(
                flex: 5,
              )
            ],
          ),
        )
      ],
    );
  }
}

class OldPacks extends StatefulWidget {
  const OldPacks({Key? key}) : super(key: key);
  @override
  State<OldPacks> createState() => _OldPacksState();
}

class _OldPacksState extends State<OldPacks> {
  final _pageController = PageController(
    viewportFraction: 0.8,
  );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var widgth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Subscriptions")
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy("subscriptionDate", descending: true)
          .get(),
      builder: ((context, AsyncSnapshot<QuerySnapshot> itemList) {
        if (itemList.connectionState == ConnectionState.waiting) {
          return const CustomLoading();
        } else if (itemList.hasError) {
          return const Text('error');
        } else if (!itemList.hasData) {
          return const Center(child: Text('No Orders yet.'));
        } else if (itemList.data!.size == 1) {
          return Center(
            child: Text(
              'No previous subscriptions...',
              style: TextStyle(fontSize: widgth * 0.05),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: itemList.data!.size,
            itemBuilder: (context, count) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: height * 0.2,
                    width: widgth,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: itemList.data!.size,
                      itemBuilder: (context, index) =>
                          _oldPackCard(index, itemList.data!.docs[index]),
                    ),
                  )
                ],
              );
            },
          );
        }
      }),
    );
  }

  _oldPackCard(int index, DocumentSnapshot snapshot) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 1.0;

          if (_pageController.position.haveDimensions) {
            value = (_pageController.page! - index);

            if (value >= 0) {
              double _lowerLimit = 0;
              double _upperLimit = 16 / 7;

              value =
                  (_upperLimit - (value.abs() * (_upperLimit - _lowerLimit)))
                      .clamp(_lowerLimit, _upperLimit);
              value = _upperLimit - value;
              value *= -1;
            }
          }
          // if (_pageController.position.haveDimensions) {
          //   value = (_pageController.page! - index);

          //   if (value >= 0) {
          //     double _lowerLimit = 0;
          //     double _upperLimit = 16 / 7;

          //     value =
          //         (_upperLimit - (value.abs() * (_upperLimit - _lowerLimit)))
          //             .clamp(_lowerLimit, _upperLimit);
          //     value = _upperLimit - value;
          //     value *= -1;
          //   }
          // } else {
          //   if (index == 0) {
          //     value = 0;
          //   } else if (index == 1) {
          //     value = -1;
          //   }
          // }

          return Container(
              height: height * 0.24,
              width: width * 0.98,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(2, 3, 3)
                  ..rotateX(value),
                //alignment: Alignment.center,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      Container(
                        color: Color.fromARGB(255, 24, 98, 224),
                      ),
                      ClipPath(
                        clipper: ProsteBezierCurve(
                          position: ClipPosition.bottom,
                          list: [
                            BezierCurveSection(
                              start: Offset(width, 0),
                              top: Offset(width / 1.59, width / 8.2),
                              end: Offset(width / 2.34, width / 2),
                            ),
                            BezierCurveSection(
                              start: Offset(width / 2, 55),
                              top: Offset(width * 0, 9100),
                              end: Offset(width * 4, 0),
                            ),
                          ],
                        ),
                        child: Container(
                          color: Color.fromARGB(255, 97, 169, 252),
                        ),
                      ),
                      OldPackCard(
                        snapshot.get('planId'),
                        (snapshot.get('subscriptionDate') as Timestamp)
                            .toDate()
                            .toString(),
                        (snapshot.get('expiryDate') as Timestamp)
                            .toDate()
                            .toString(),
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
