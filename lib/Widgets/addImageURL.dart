import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:laundryappv2/Models/product.dart';
import 'package:laundryappv2/Widgets/textFormField.dart';
import 'package:provider/provider.dart';

class AddImageURL extends StatefulWidget {
  const AddImageURL({super.key});

  @override
  State<AddImageURL> createState() => _AddImageURLState();
}

class _AddImageURLState extends State<AddImageURL> {
  @override
  Widget build(BuildContext context) {
    final imageHandler = Provider.of<ImageHandler>(context, listen: false);
    double padding = MediaQuery.of(context).size.height * 0.03 / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image URL', style: Theme.of(context).textTheme.headline1),
        Padding(padding: EdgeInsets.all(padding)),
        CustomTextField(
            textEditingController: imageHandler.imageUrlController,
            fieldName: 'Image URL',
            icon: const Icon(Icons.checkroom_rounded,
                color: Color.fromARGB(255, 61, 60, 60)))
      ],
    );
  }
}
