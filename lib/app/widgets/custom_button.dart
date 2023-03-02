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
  final FontWeight? fontWeight;
  final double? radius;
  final Widget? child;
  final EdgeInsets? padding;

  const CustomButton(
      {Key? key,
      this.text,
      @required this.onPressed,
      this.backgroundColor,
      this.color,
      this.height,
      this.width,
      this.fontSize = 14,
      this.fontWeight = FontWeight.bold,
      this.radius = 6,
      this.borderColor = colorTextBlack,
      this.padding = const EdgeInsets.symmetric(vertical: 14),
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: padding,
            elevation: 0.0,
            fixedSize: Size(width ?? Get.width, height ?? 50),
            backgroundColor: backgroundColor,
            disabledBackgroundColor: colorTextGrey,
            side: BorderSide(
                width: 1.0,
                color: (onPressed != null) ? borderColor! : Colors.transparent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!),
            )),
        child: (child != null)
            ? child
            : CustomText(
                text: text!,
                color: color,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ));
  }
}
