import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String? _userId;
  String? name;
  String? email;
  String? fcmToken;
  bool signUpMode = true;
  String? get userId {
    _userId = FirebaseAuth.instance.currentUser!.uid;
    return _userId;
  }

  Auth();
  Auth.construct(this.name, this.email, this._userId, this.fcmToken);
  Map<String, dynamic> toJson() => _authToJson(this);
  Map<String, dynamic> _authToJson(Auth auth) => <String, dynamic>{
        'userId': auth._userId,
        'name': auth.name,
        'email': auth.email,
        'fcmToken': fcmToken
      };
  void toggleSignUp() {
    signUpMode = !signUpMode;
    notifyListeners();
  }

  Future<QuerySnapshot> fetchPlans() async {
    return await FirebaseFirestore.instance.collection("Plans").get();
  }

  Future<DocumentReference> addUserDatatoDB(
      String name, String email, String userId) {
    Auth item = Auth.construct(name, email, userId, fcmToken);
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('UserData');
    return collection.add(item.toJson());
  }
}
