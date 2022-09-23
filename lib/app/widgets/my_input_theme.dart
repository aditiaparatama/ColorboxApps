import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class MyInputTheme {
  TextStyle _builtTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ));
  }

  InputDecorationTheme theme() => InputDecorationTheme(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //isDense seems to do nothing if you pass padding in
        // isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        //this can be useful for putting TextFields in a row.
        //However, it might be more desirable to wrap with Flexible
        //to make them grow to the available width.
        // constraints: const BoxConstraints(maxWidth: 150),

        //Borders
        //Enabled and not showing error
        enabledBorder: _buildBorder(const Color(0xFFE5E8EB)),
        focusedBorder: _buildBorder(colorTextBlack),
        //Has error but not focus
        errorBorder: _buildBorder(colorTextRed),
        // Has error and focus
        focusedErrorBorder: _buildBorder(colorTextRed),
        // Default value if borders are null
        border: _buildBorder(colorTextBlack),
        // Enabled and focused
        disabledBorder: _buildBorder(const Color(0xFFE5E8EB)),

        // TextStyles
        suffixStyle: _builtTextStyle(colorTextBlack),
        counterStyle: _builtTextStyle(Colors.grey, size: 14.0),
        floatingLabelStyle: _builtTextStyle(colorTextBlack),
        // Make error and helper the same size, so that the field
        // does not grow in heigth when there is an error text
        errorStyle: _builtTextStyle(colorTextRed, size: 12.0),
        helperStyle: _builtTextStyle(colorTextBlack, size: 14.0),
        hintStyle: _builtTextStyle(colorTextGrey, size: 14),
        labelStyle: _builtTextStyle(colorTextGrey, size: 14),
        prefixStyle: _builtTextStyle(colorTextBlack),
      );
}
