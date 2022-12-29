import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Widgets/customLoading.dart';
import 'package:laundryappv2/Widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Text(
              'Notifications',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ),
        Flexible(
            child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Notifications")
                    .where("mail",
                        isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .orderBy("timeStamp", descending: true)
                    .get(),
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoading();
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                  if (snapshot.data!.size == 0) {
                    return const Center(
                      child: Text('No notifications yet...'),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          return NotificationCard(
                              date: (snapshot.data!.docs[index].get('timeStamp')
                                      as Timestamp)
                                  .toDate(),
                              mode: snapshot.data!.docs[index].get('mode'));
                        }));
                  }
                })))
      ],
    );
  }
}
