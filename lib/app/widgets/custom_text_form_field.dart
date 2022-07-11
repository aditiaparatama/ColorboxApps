import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? text;
  final String? hint;
  final bool? obscureText, readOnly;
  final IconButton? iconButton;
  final String? prefixText;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final TextAlign? textAlign;
  // ignore: prefer_typing_uninitialized_variables
  final onSave;
  // ignore: prefer_typing_uninitialized_variables
  final validator;

  const CustomTextFormField(
      {Key? key,
      this.text,
      this.hint = "",
      @required this.onSave,
      @required this.validator,
      this.obscureText = false,
      this.readOnly = false,
      this.iconButton,
      this.prefixText,
      this.textInputType,
      this.textEditingController,
      this.textAlign = TextAlign.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (text == null)
        const Padding(padding: EdgeInsets.all(0))
      else
        Container(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: text!,
            fontSize: 14,
            color: Colors.grey.shade900,
          ),
        ),
      TextFormField(
        controller: textEditingController,
        onSaved: onSave,
        validator: validator,
        obscureText: obscureText!,
        keyboardType: textInputType,
        readOnly: readOnly!,
        textAlign: textAlign!,
        decoration: InputDecoration(
            hintText: hint!, suffixIcon: iconButton, prefixText: prefixText),
      )
    ]);
  }
}
