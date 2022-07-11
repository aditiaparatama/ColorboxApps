import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors
class RegisterView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const CustomText(
            text: 'PROFILE',
            fontSize: 20,
          ),
          centerTitle: true,
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
                      height: Get.height * .88,
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
                                    const CustomText(
                                      text: "Create Account",
                                      fontSize: 30,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      text: 'First Name',
                                      onSave: (value) {
                                        controller.firstName = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          Get.snackbar("Warning",
                                              "First Name must be filled");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      text: 'Last Name',
                                      onSave: (value) {
                                        controller.lastName = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          Get.snackbar("Warning",
                                              "Last Name must be filled");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      text: 'Phone',
                                      textInputType: TextInputType.number,
                                      prefixText: "+62",
                                      onSave: (value) {
                                        controller.phone = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          Get.snackbar("Warning",
                                              "Phone must be filled");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      text: 'Email',
                                      onSave: (value) {
                                        controller.email = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          Get.snackbar("Warning",
                                              "Email must be filled");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      text: 'Password',
                                      obscureText: true,
                                      onSave: (value) {
                                        controller.password = value;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          Get.snackbar("Warning",
                                              "Password must be filled");
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 40,
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
                                                await controller.register();
                                            if (result == "success") {
                                              Get.back();
                                              Get.snackbar("Congratulations!",
                                                  "Data has been created");
                                            } else {
                                              controller.loading.value = false;
                                              controller.update();
                                            }
                                          }
                                        },
                                        text: "CREATE",
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () =>
                                            Get.offNamed(Routes.PROFILE),
                                        child: const CustomText(
                                          text:
                                              "Log in with an existing account",
                                          decoration: TextDecoration.underline,
                                        ))
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
