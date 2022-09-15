import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class CustomSearchTextForm extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final onChanged;
  // ignore: prefer_typing_uninitialized_variables
  final onSaved;
  // ignore: prefer_typing_uninitialized_variables
  final validator;
  final String? textHint;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? borderColorFocused;
  final TextInputType? textInputType;
  const CustomSearchTextForm({
    Key? key,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.textHint,
    this.radius = 6,
    this.borderColor = const Color(0xFFE5E8EB),
    this.borderColorFocused = const Color(0xFFE5E8EB),
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: colorTextBlack,
      keyboardType: textInputType,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
          hintText: textHint!,
          suffixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9B9B9B),
          ),
          filled: true,
          fillColor: backgroundColor,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius!)),
              borderSide: BorderSide(color: borderColorFocused!, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius!)),
              borderSide: BorderSide(color: borderColor!))),
    );
  }
}
