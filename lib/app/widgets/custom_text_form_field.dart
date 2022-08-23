import 'package:flutter/material.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final String? text, hint;
  final bool? obscureText, readOnly, enabled;
  final Widget? suffixIcon;
  final String? prefixText;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  // ignore: prefer_typing_uninitialized_variables
  final onSave, onChange, validator;
  // ignore: prefer_typing_uninitialized_variables

  const CustomTextFormField(
      {Key? key,
      this.text,
      this.hint = "",
      @required this.onSave,
      @required this.validator,
      this.obscureText = false,
      this.readOnly = false,
      this.enabled = true,
      this.suffixIcon,
      this.prefixText,
      this.textInputType,
      this.textEditingController,
      this.textAlign = TextAlign.left,
      this.focusNode,
      this.onChange})
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
        focusNode: focusNode,
        cursorColor: Colors.black,
        controller: textEditingController,
        onChanged: onChange,
        onSaved: onSave,
        validator: validator,
        obscureText: obscureText!,
        keyboardType: textInputType,
        readOnly: readOnly!,
        enabled: enabled,
        textAlign: textAlign!,
        decoration: InputDecoration(
            labelText: hint!, suffixIcon: suffixIcon, prefixText: prefixText),
      )
    ]);
  }
}
