import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class OrderItem {
  String? id;
  String? mail;
  Map<String, int> clothes;
  DateTime dateTime;
  OrderItem(this.clothes, this.dateTime);
  bool isDelivered = false;
  bool isVerified = false;
  bool hasError = false;
  DateTime? deliveryDate;
  OrderItem.constructfromjson(
      {required this.deliveryDate,
      required this.clothes,
      required this.dateTime,
      required this.isDelivered,
      required this.isVerified,
      required this.hasError});
  OrderItem.constructfromjsonadmin(
      {required this.id,
      required this.mail,
      required this.clothes,
      required this.dateTime,
      required this.isDelivered,
      required this.isVerified,
      required this.hasError});

  int get totalCloth {
    int sum = 0;
    clothes.forEach((key, value) {
      sum += value;
    });
    return sum;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      OrderItem.constructfromjson(
        deliveryDate: json['deliveryDate'],
        clothes: json['Clothes'] as Map<String, int>,
        dateTime: json['Timestamp'],
        isDelivered: json['isDelivered'],
        isVerified: json['isVerified'],
        hasError: json['hasError'],
      );
  Map<String, dynamic> toJson(String userid) => _orderItemToJson(this, userid);
}

Map<String, dynamic> _orderItemToJson(OrderItem item, String userId) =>
    <String, dynamic>{
      'Clothes': item.clothes,
      'TimeStamp': item.dateTime,
      'UserId': userId,
      'Email': FirebaseAuth.instance.currentUser!.email,
      'isVerified': false,
      'isDelivered': false,
      'hasError': false,
      'deliveryDate': null
    };

class Orders with ChangeNotifier {
  final Auth? auth;
  Orders(this.auth);
  List<OrderItem> _orderList = [];
  String searchString = "";

  Future<String> getClientToken(String mail) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("UserData")
        .where("email", isEqualTo: mail)
        .get();
    return querySnapshot.docs.first.get('fcmToken');
  }

  Future<void> sendNotification(String mail, String body, String title) async {
    var token = await getClientToken(mail);

    var response = await post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=' + 'insert-fcm-key-here',
      },
      body: json.encode({
        'notification': {'body': body, 'title': title},
        'data': {'message': body},
        'to': token,
        //  data={notification:{body:"",title:"",icon:""},data:{message:""},registration_ids:[]}
      }),
    );
    print(response.body);
  }

  Future<void> addOrder(Map<String, int> cartItem) async {
    await addOrdertoDB(OrderItem(cartItem, DateTime.now()));
  }

  Future<void> updateOrder(String mail, String id, String mode) async {
    if (mode.contains('verify')) {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Orders');
      await collection.doc(id).update({'isVerified': true});
    }
    if (mode.contains('deliver')) {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Orders');
      await collection
          .doc(id)
          .update({'deliveryDate': DateTime.now(), 'isDelivered': true});
    }
    if (mode.contains('reject')) {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Orders');
      await collection.doc(id).delete();
    }

    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Notifications');
    await collection.add(<String, dynamic>{
      'mail': mail,
      'timeStamp': DateTime.now(),
      'mode': mode
    });
  }

  Future<List<OrderItem>> fetchOrdersUser() async {
    List<OrderItem> list = [];

    final QuerySnapshot<Map<String, dynamic>> querySnapshot;

    querySnapshot = await FirebaseFirestore.instance
        .collection("Orders")
        .where("UserId", isEqualTo: auth!.userId!)
        .orderBy('TimeStamp', descending: true)
        .get();

    for (var doc in querySnapshot.docs) {
      var clothes = doc.get('Clothes');

      var newMap = Map<String, int>.from(clothes);
      Map<String, int> newnewMap = {};

      newnewMap.addEntries(newMap.entries);

      list.add(OrderItem.constructfromjson(
          clothes: newnewMap,
          deliveryDate: doc.get('deliveryDate') == null
              ? null
              : stamptoDateTime(doc.get('deliveryDate')),
          dateTime: stamptoDateTime(doc.get('TimeStamp')),
          isDelivered: doc.get('isDelivered'),
          isVerified: doc.get('isVerified'),
          hasError: doc.get('hasError')));
    }
    return list;
  }

  Future<List<OrderItem>> convertsnapshot(
      AsyncSnapshot<QuerySnapshot> querySnapshot) async {
    List<OrderItem> list = [];
    for (var doc in querySnapshot.data!.docs) {
      var clothes = doc.get('Clothes');

      var newMap = Map<String, int>.from(clothes);
      Map<String, int> newnewMap = {};

      newnewMap.addEntries(newMap.entries);

      list.add(OrderItem.constructfromjsonadmin(
          id: doc.id.toString(),
          mail: doc.get('Email').toString(),
          clothes: newnewMap,
          dateTime: stamptoDateTime(doc.get('TimeStamp')),
          isDelivered: doc.get('isDelivered'),
          isVerified: doc.get('isVerified'),
          hasError: doc.get('hasError')));
    }
    list.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );
    print('list :${list}');
    return list;
  }

  Future<OrderItem?> fetchCurrentOrder() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Orders")
        .where("UserId", isEqualTo: auth!.userId!)
        .orderBy('TimeStamp', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final firstdoc = querySnapshot.docs.first;
      final clothes = firstdoc.get('Clothes');

      final newMap = Map<String, int>.from(clothes);
      Map<String, int> newnewMap = {};
      for (var i in newMap.entries) {
        newnewMap.addEntries(newMap.entries);
      }
      return OrderItem.constructfromjson(
          clothes: newnewMap,
          dateTime: stamptoDateTime(firstdoc.get('TimeStamp')),
          deliveryDate: firstdoc.get('deliveryDate') == null
              ? null
              : stamptoDateTime(firstdoc.get('deliveryDate')),
          isDelivered: firstdoc.get('isDelivered'),
          isVerified: firstdoc.get('isVerified'),
          hasError: firstdoc.get('hasError'));
    } else {
      return null;
    }
  }

  DateTime stamptoDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  void setSearch(String searchController) {
    searchString = searchController;
    notifyListeners();
  }

  //Map<String,int> getclothes
  Future<DocumentReference> addOrdertoDB(OrderItem item) {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Orders');
    return collection.add(item.toJson(auth!.userId!));
  }

  List<OrderItem> get orderList {
    return [..._orderList];
  }
}
