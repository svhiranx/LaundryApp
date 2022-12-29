import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:laundryappv2/Models/plans.dart';
import 'package:laundryappv2/Screens/Admin/admin_all_orders_screen.dart';
import 'package:laundryappv2/Widgets/customDialog.dart';
import 'package:laundryappv2/Widgets/textFormField.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class AddPlansScreen extends StatefulWidget {
  const AddPlansScreen({super.key});

  @override
  State<AddPlansScreen> createState() => _AddPlansScreenState();
}

class _AddPlansScreenState extends State<AddPlansScreen> {
  int currentHorizontalIntValue = 1;
  TextEditingController titleController = TextEditingController(),
      priceController = TextEditingController(),
      clothcountController = TextEditingController();
  final _Form = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.height * 0.03;

    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.50),
        child: Form(
          key: _Form,
          child: Column(
            children: [
              Text(
                'Add New Plan',
                style: Theme.of(context).textTheme.headline1,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: padding,
                runSpacing: padding,
                children: [
                  Text('Title', style: Theme.of(context).textTheme.headline2),
                  CustomTextField(
                    fieldName: 'Title',
                    textEditingController: titleController,
                    icon: const Icon(Icons.abc),
                  ),
                  Text('Duration in Months',
                      style: Theme.of(context).textTheme.headline2),
                  NumberPicker(
                    value: currentHorizontalIntValue,
                    minValue: 1,
                    maxValue: 48,
                    step: 1,
                    itemHeight: padding * 4,
                    axis: Axis.horizontal,
                    onChanged: (value) =>
                        setState(() => currentHorizontalIntValue = value),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                  Text('Clothes Per Month',
                      style: Theme.of(context).textTheme.headline2),
                  CustomTextField(
                    fieldName: 'Clothes Limit per Month ',
                    textEditingController: clothcountController,
                    icon: const Icon(Icons.checkroom),
                  ),
                  Text('Price', style: Theme.of(context).textTheme.headline2),
                  CustomTextField(
                    fieldName: 'Price',
                    textEditingController: priceController,
                    icon: const Icon(Icons.currency_rupee),
                  ),
                  Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (_Form.currentState!.validate()) {
                                  isLoading = true;
                                  Provider.of<Plan>(context, listen: false)
                                      .addPlantoDB(Plan(
                                    title: titleController.text,
                                    clothespermonth:
                                        int.parse(clothcountController.text),
                                    months: currentHorizontalIntValue,
                                    price: int.parse(priceController.text),
                                  ));
                                  isLoading = false;
                                } else
                                  null;
                              },
                              child: const Text('Submit'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
