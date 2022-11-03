import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

Future<bool> popUpAlert(
    BuildContext context, String title, Widget content, action) async {
  return await showDialog(
        //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: CustomText(
            text: title,
            fontSize: 14,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          content: content,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                backgroundColor: colorTextBlack,
                color: Colors.white,
                onPressed: action,
                //return false when click on "No"
                text: 'Kembali',
                fontSize: 14,
                height: 48,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ) ??
      false; //if showDialouge had returned null, then return false
}
