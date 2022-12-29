import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
        child: SizedBox(
      height: width / 2,
      width: width / 2,
      child: LoadingIndicator(
        indicatorType: Indicator.ballClipRotateMultiple,
        strokeWidth: 3,
      ),
    ));
  }
}
