import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:laundryappv2/Models/auth.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Models/plans.dart';

class Subscription {
  String? planId;
  DateTime? subcriptionDate;
  DateTime? expiryDate; //months
  int? clothCount;
  Subscription(
      {this.planId, this.subcriptionDate, this.expiryDate, this.clothCount});
  Map<String, dynamic> toJson(String userId) =>
      _subscriptionToJson(this, userId);
}

Map<String, dynamic> _subscriptionToJson(
        Subscription subscription, String userId) =>
    <String, dynamic>{
      'userId': userId,
      'planId': subscription.planId,
      'subscriptionDate': subscription.subcriptionDate,
      'expiryDate': subscription.expiryDate,
      'clothCount': subscription.clothCount
    };

class SubscriptionData with ChangeNotifier {
  Auth? auth;
  int balance = 0;
  String? durationBeforeNextOrder;
  int cycles = 0;
  bool isLoading = false;
  SubscriptionData(this.auth);

  Future<DocumentReference> subscribe(Plan plan) {
    Subscription item = Subscription(
        clothCount: plan.clothespermonth,
        subcriptionDate: DateTime.now(),
        planId: plan.title,
        expiryDate:
            DateTime.now().add(Duration(days: 30 * (plan.months as int))));
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Subscriptions');
    return collection.add(item.toJson(FirebaseAuth.instance.currentUser!.uid));
  }

  Future<void> fetchbalance() async {
    isLoading = true;
    notifyListeners();
    List<dynamic> ass = await fetchSubscription();
    balance = ass[3];
    isLoading = false;
    notifyListeners();
  }

  void incrementBalance() {
    balance++;
    notifyListeners();
  }

  void decrementBalance() {
    balance--;
    notifyListeners();
  }

  Future<dynamic> fetchSubscription() async {
    List<OrderItem> orderList = [];
    int monthlyCount = 0;
    int monthlyCycles = 0;

    var subscriptionData = await FirebaseFirestore.instance
        .collection("Subscriptions")
        .where("userId", isEqualTo: auth!.userId!)
        .orderBy("subscriptionDate", descending: true)
        .get();
    var orderData = await FirebaseFirestore.instance
        .collection("Orders")
        .where("UserId", isEqualTo: auth!.userId!)
        .where(
          "TimeStamp",
          isGreaterThanOrEqualTo: DateTime.now().subtract(
            Duration(days: 30),
          ),
        )
        .orderBy("TimeStamp", descending: true)
        .get();

    if (subscriptionData.docs.isEmpty) return null;

    for (var doc in orderData.docs) {
      var clothes = doc.get('Clothes');

      var newMap = Map<String, int>.from(clothes);
      Map<String, int> newnewMap = {};
      for (var i in newMap.entries) {
        newnewMap.addEntries(newMap.entries);
      }

      orderList.insert(
          0,
          OrderItem.constructfromjson(
              deliveryDate: doc.get('deliveryDate') == null
                  ? null
                  : stamptoDateTime(doc.get('deliveryDate')),
              clothes: newnewMap,
              dateTime: stamptoDateTime(doc.get('TimeStamp')),
              isDelivered: doc.get('isDelivered'),
              isVerified: doc.get('isVerified'),
              hasError: doc.get('hasError')));
    }

    for (var element in orderList) {
      if (!element.hasError) monthlyCount = monthlyCount + element.totalCloth;
    }

    print(monthlyCount);
    monthlyCycles = orderList.length;
    return [
      Subscription(
        planId: subscriptionData.docs.first.get('planId'),
        clothCount: subscriptionData.docs[0].get('clothCount'),
        expiryDate:
            (subscriptionData.docs[0].get('expiryDate') as Timestamp).toDate(),
        subcriptionDate:
            stamptoDateTime(subscriptionData.docs[0].get('subscriptionDate')),
      ),
      monthlyCount,
      monthlyCycles,
      subscriptionData.docs[0].get('clothCount') - monthlyCount,
    ];
  }

  DateTime stamptoDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
