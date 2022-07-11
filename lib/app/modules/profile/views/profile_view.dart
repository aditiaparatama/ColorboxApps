import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors
class ProfileView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: 'Masuk Akun',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: GetBuilder<ProfileController>(builder: (controller) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      height: Get.height * .65,
                      width: Get.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, right: 20, left: 20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: "Email",
                                      ),
                                      onSaved: (value) {
                                        controller.email = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          // ignore: avoid_print
                                          print("ERROR");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: "Password",
                                      ),
                                      obscureText: true,
                                      onSaved: (value) {
                                        controller.password = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          // ignore: avoid_print
                                          print("ERROR");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const CustomText(
                                      text: 'Lupa Password?',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(17, 90, 200, 1),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: CustomButton(
                                        backgroundColor: colorPrimary,
                                        color: secondColor,
                                        onPressed: () async {
                                          _formKey.currentState!.save();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            var result =
                                                await controller.login();
                                            if (result == "1") {
                                              Get.back();
                                              Get.find<SettingsController>()
                                                  .getUser();
                                              Get.find<SettingsController>()
                                                  .update();
                                            } else {
                                              Get.snackbar("Warning", result,
                                                  snackPosition:
                                                      SnackPosition.BOTTOM);
                                            }
                                          }
                                        },
                                        text: "Masuk",
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const CustomText(
                                      text: 'Belum Punya Akun?',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    const CustomText(
                                      text: 'Daftar Akun',
                                      fontSize: 12,
                                      color: Color.fromRGBO(17, 90, 200, 1),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: CustomButton(
                                        backgroundColor: secondColor,
                                        color: colorPrimary,
                                        onPressed: () =>
                                            Get.offNamed(Routes.REGISTER),
                                        text: "SIGN UP",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controller.loading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.grey,
                    ))
                  : const SizedBox()
            ],
          );
        }));
  }
}
