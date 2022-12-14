import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final String? text;
  final dynamic onChange;
  const CustomCheckbox(
      {Key? key, required this.value, this.onChange, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          activeColor: colorTextBlack,
          value: value,
          onChanged: onChange,
        ),
        if (text != null)
          CustomText(
            text: text,
          ),
      ],
    );
  }
}
