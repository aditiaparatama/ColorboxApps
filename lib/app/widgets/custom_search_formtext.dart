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
    this.borderColor = Colors.transparent,
    this.borderColorFocused = Colors.grey,
    this.backgroundColor = const Color(0xFFF5F6F8),
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: textInputType,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
          hintText: textHint!,
          suffixIcon: const Icon(Icons.search),
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
