import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  // ignore: prefer_typing_uninitialized_variables
  final onPressed;
  final Color? backgroundColor;
  final Color? color;

  const CustomButton(
      {Key? key,
      this.text,
      @required this.onPressed,
      this.backgroundColor,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(18),
            fixedSize: Size(Get.width - 50, 50),
            backgroundColor: backgroundColor,
            side: const BorderSide(width: 1.0, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: CustomText(
          text: text!,
          color: color,
          fontWeight: FontWeight.bold,
        ));
  }
}
