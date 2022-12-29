import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Plan with ChangeNotifier {
  String? title;
  String? id;
  int? months;
  int? clothespermonth;
  int? price;
  Plan({this.id, this.title, this.months, this.clothespermonth, this.price});
  Map<String, dynamic> toJson() => _planToJson(this);
  Map<String, dynamic> _planToJson(Plan plan) => <String, dynamic>{
        'title': plan.title,
        'months': plan.months,
        'clothesPerMonth': plan.clothespermonth,
        'price': plan.price,
      };
  Future<DocumentReference> addPlantoDB(Plan item) {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Plans');
    return collection.add(item.toJson());
  }

  Future<QuerySnapshot> fetchPlans() async {
    return await FirebaseFirestore.instance.collection("Plans").get();
  }

  Future<dynamic> fetchPlansAndCheckSub() async {
    bool isValidSub = true;
    var querySnapshot =
        await FirebaseFirestore.instance.collection("Plans").get();
    var subscriptionData = await FirebaseFirestore.instance
        .collection("Subscriptions")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("subscriptionDate", descending: true)
        .get();
    DateTime expiryDate =
        (subscriptionData.docs.first.get('expiryDate') as Timestamp).toDate();
    if (DateTime.now().isAfter(expiryDate)) isValidSub = false;
    return [querySnapshot, isValidSub];
  }
}
