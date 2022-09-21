import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  // ignore: prefer_typing_uninitialized_variables
  final onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? color;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final Widget? child;

  const CustomButton(
      {Key? key,
      this.text,
      @required this.onPressed,
      this.backgroundColor,
      this.color,
      this.height,
      this.width,
      this.fontSize = 14,
      this.radius = 6,
      this.borderColor = colorTextBlack,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0.0,
            fixedSize: Size(width ?? Get.width, height ?? 50),
            backgroundColor: backgroundColor,
            disabledBackgroundColor: colorTextGrey,
            side: BorderSide(width: 1.0, color: borderColor!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!),
            )),
        child: (child != null)
            ? child
            : CustomText(
                text: text!,
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ));
  }
}
