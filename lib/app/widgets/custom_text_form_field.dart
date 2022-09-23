import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  final String? text, hint;
  final bool? obscureText, readOnly, enabled, showAlert;
  final Widget? suffixIcon;
  final String? prefixText;
  final Widget? prefix;
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
      this.showAlert = false,
      this.suffixIcon,
      this.prefixText,
      this.prefix,
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
        autocorrect: false,
        enableSuggestions: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        cursorColor: colorTextBlack,
        controller: textEditingController,
        onChanged: onChange,
        onSaved: onSave,
        validator: validator,
        obscureText: obscureText!,
        keyboardType: textInputType,
        readOnly: readOnly!,
        enabled: enabled,
        textAlign: textAlign!,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: hint!,
          floatingLabelStyle: TextStyle(
              color: (showAlert!) ? colorTextRed : colorTextBlack,
              fontSize: 14),
          suffixIcon: (showAlert!)
              ? Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SvgPicture.asset(
                    "assets/icon/circle-exclamation-solid.svg",
                  ),
                )
              : suffixIcon,
          prefixText: prefixText,
          prefix: prefix,
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: (textEditingController != null &&
                        textEditingController!.text.isNotEmpty)
                    ? colorTextBlack
                    : const Color(0xFFE5E8EB),
                width: 1.0,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: (textEditingController != null &&
                        textEditingController!.text.isNotEmpty)
                    ? colorTextBlack
                    : const Color(0xFFE5E8EB),
                width: 1.0,
              )),
        ),
      )
    ]);
  }
}
