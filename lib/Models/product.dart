import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundryappv2/Models/auth.dart';

class Product {
  final String? id;
  final String? title;

  final String? imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  Map<String, dynamic> toJson() => _productItemToJson(this);
}

Map<String, dynamic> _productItemToJson(Product item) => <String, dynamic>{
      'title': item.title,
      'imageUrl': item.imageUrl,
    };

class Products with ChangeNotifier {
  Auth? auth;

  Products(this.auth);

  Future<dynamic> fetchProducts() async {
    String? durationBeforeNextOrder;
    int? monthlycycles;
    var querySnapshot =
        await FirebaseFirestore.instance.collection("Products").get();
    List<dynamic> fetchedData = await fetchTimeBeforeNextOrder();
    if (fetchedData.isEmpty) {
      durationBeforeNextOrder = null;
      monthlycycles = 0;
    } else {
      durationBeforeNextOrder = fetchedData[0];
      monthlycycles = fetchedData[1];
    }
    return [querySnapshot, monthlycycles, durationBeforeNextOrder];
  }

  static Future<DocumentReference> addOrdertoDB(Product item) {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Products');
    return collection.add(item.toJson());
  }

  Future<List<dynamic>> fetchTimeBeforeNextOrder() async {
    var orderData = await FirebaseFirestore.instance
        .collection("Orders")
        .where("UserId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where(
          "TimeStamp",
          isGreaterThanOrEqualTo: DateTime.now().subtract(
            Duration(days: 30),
          ),
        )
        .orderBy("TimeStamp", descending: true)
        .get();

    Duration? timeBeforeNextOrder;
    if (orderData.docs.isEmpty) return [];

    DateTime dateBeforeMonth =
        DateTime.now().subtract(const Duration(days: 30));

    DateTime lastOrderDate =
        (orderData.docs.last.get('TimeStamp') as Timestamp).toDate();

    timeBeforeNextOrder = lastOrderDate.difference(dateBeforeMonth);

    int cycles = orderData.docs.length;
    String durationBeforeNextOrder;

    if (timeBeforeNextOrder.inDays >= 31) {
      durationBeforeNextOrder =
          "${(timeBeforeNextOrder.inDays / 7).round()} Weeks";
    } else if (timeBeforeNextOrder.inHours >= 24) {
      durationBeforeNextOrder = "${(timeBeforeNextOrder.inDays).round()} Days";
    } else if (timeBeforeNextOrder.inMinutes >= 60) {
      durationBeforeNextOrder =
          "${(timeBeforeNextOrder.inHours).round()} Hours";
    } else if (timeBeforeNextOrder.inSeconds >= 60) {
      durationBeforeNextOrder = "${(timeBeforeNextOrder.inMinutes).round()} m";
    } else {
      durationBeforeNextOrder = "${(timeBeforeNextOrder.inSeconds).round()} s";
    }

    return [durationBeforeNextOrder, cycles];
  }
}

class ImageHandler with ChangeNotifier {
  File? image;
  TextEditingController imageUrlController = TextEditingController();
  Future pickImage() async {
    try {
      final ximage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (ximage == null) return;
      final imageTemporary = File(ximage.path);

      image = imageTemporary;
      notifyListeners();
    } on PlatformException catch (error) {
      print(error);
    }
  }

  bool get hasimage {
    return image != null;
  }

  void deleteImage() {
    image = null;
    notifyListeners();
  }

  Future<String?> uploadFile() async {
    UploadTask uploadTask;
    final ximage = XFile(image!.path);
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('product_image')
        .child('/${ximage.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': ximage.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await ximage.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(image!.path), metadata);
    }
    await Future.value(uploadTask);

    return await ref.getDownloadURL();
  }
}
