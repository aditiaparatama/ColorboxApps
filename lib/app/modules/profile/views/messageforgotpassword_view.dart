import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
// import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class MessageForgotPasswordView extends GetView<ProfileController> {
  static const str = 'date: 2019:04:01';
  final valuestest = str.split(': ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const CustomText(
          text: "Reset Password",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: EmptyPage(
        image: Image.asset(
          "assets/icon/password.gif",
          height: 180,
        ),
        textHeader: "Reset Password",
        textContent:
            "Periksa email, kami telah mengirim tautan untuk memperbaharui password",
      ),
    );
  }
}
