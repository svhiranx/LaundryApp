import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundryappv2/Models/product.dart';
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  AddImage({
    super.key,
  });

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    final imageHandler = Provider.of<ImageHandler>(context, listen: true);
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Add Image', style: Theme.of(context).textTheme.headline2),
            ElevatedButton(
              onPressed: (() async {
                await imageHandler.pickImage();
              }),
              child: Text(
                  imageHandler.image != null ? 'Change Image' : 'Add Image'),
            ),
          ],
        ),
        imageHandler.image != null
            ? Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    height: width * 0.5,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.file(imageHandler.image!),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => imageHandler.deleteImage(),
                    splashRadius: 20,
                  )
                ],
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: const Text('No Image Added :('),
              ),
      ],
    );
  }
}
