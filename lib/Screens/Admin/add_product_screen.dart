import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Widgets/addImage.dart';
import 'package:laundryappv2/Widgets/addImageURL.dart';
import 'package:laundryappv2/Widgets/customDialog.dart';
import 'package:laundryappv2/Widgets/textFormField.dart';
import 'package:provider/provider.dart';
import '../../Models/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool getURL = false;
  bool isLoading = false;
  File? image;
  TextEditingController titleController = TextEditingController();
  TextEditingController clothController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<void> _saveForm(bool isValid) async {
    setState(() {
      isLoading = true;
    });

    final imageHandler = Provider.of<ImageHandler>(context, listen: false);
    if (getURL) {
      Products.addOrdertoDB(Product(
          title: titleController.text,
          imageUrl: imageHandler.imageUrlController.text));
    } else {
      String? url = await imageHandler.uploadFile();
      if (url != null) {
        Products.addOrdertoDB(
            Product(title: titleController.text, imageUrl: url));
      }
    }

    print("Saved");
    showDialog(
        barrierDismissible: false, //to disable external touch
        context: context,
        builder: (context) {
          return CustomDialog(
              title: 'Product Added!',
              message: 'Product has been successfully added with no errors!');
        });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.height * 0.03;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.all(padding),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Add new product',
                          style: Theme.of(context).textTheme.headline1),
                    ),
                    Padding(padding: EdgeInsets.all(padding)),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: padding,
                      runSpacing: padding,
                      children: [
                        Text('Title',
                            style: Theme.of(context).textTheme.headline2),
                        CustomTextField(
                            textEditingController: titleController,
                            fieldName: 'Title',
                            icon: const Icon(Icons.checkroom_rounded,
                                color: Color.fromRGBO(61, 60, 60, 1))),
                        getURL ? const AddImageURL() : AddImage(),
                        TextButton(
                            onPressed: () => setState(() {
                                  getURL = !getURL;
                                }),
                            child: Text(getURL
                                ? 'Add Image File instead...'
                                : 'Add image URL instead..')),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final isValid = _formkey.currentState!.validate();
                          if (!isValid) return;
                          _saveForm(isValid);
                        },
                        //      !getURL &&
                        //     !Provider.of<ImageHandler>(context,
                        //             listen: true)
                        //         .hasimage
                        // ? () => {
                        //       showDialog(
                        //           barrierDismissible:
                        //               false, //to disable external touch
                        //           context: context,
                        //           builder: (context) {
                        //             return CustomDialog(
                        //                 title: 'Error >:(',
                        //                 message: 'Please Add Image!');
                        //           })
                        //     }
                        // : () async {
                        //     _saveForm();
                        //     _formkey.currentState!.reset();
                        //   },
                        child: const Text('Submit'))
                  ],
                ),
              ),
            ),
          );
  }
}
