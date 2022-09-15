import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextDecoration? decoration;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final double? lineHeight;

  const CustomText(
      {Key? key,
      this.text,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 14,
      this.color = colorTextBlack,
      this.decoration = TextDecoration.none,
      this.textOverflow = TextOverflow.ellipsis,
      this.textAlign = TextAlign.left,
      this.lineHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      overflow: textOverflow,
      style: TextStyle(
          fontSize: fontSize,
          color: color,
          decoration: decoration,
          fontWeight: fontWeight,
          height: lineHeight),
      textAlign: textAlign,
    );
  }
}
