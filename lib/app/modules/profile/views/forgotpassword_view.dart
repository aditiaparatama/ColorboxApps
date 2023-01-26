import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
// import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class ForgotPasswordView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController birthday = TextEditingController();

  static const str = 'date: 2019:04:01';
  final valuestest = str.split(': ');
  bool emailAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: AppBarDefault(
              text: "Reset Password",
            )),
        body: GetBuilder<ProfileController>(builder: (_) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: const <Widget>[
                                        Text(
                                          'Masukkan alamat email Anda, kami akan mengirimkan email untuk mereset password ',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      hint: "Email",
                                      showAlert: emailAlert,
                                      onSave: (value) {
                                        controller.email = value;
                                      },
                                      onChange: (value) => controller.update(),
                                      validator: (value) {
                                        if (RegExp(
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                            .hasMatch(value!)) {
                                          emailAlert = false;
                                          return null;
                                        }
                                        emailAlert = true;
                                        return "Format email salah";
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
                                            var result = await controller
                                                .forgotpassword();
                                            if (result == "success") {
                                              Get.offNamed(
                                                  Routes.MESSAGEFORGOTPASSWORD);
                                            } else {
                                              // Get.snackbar("Warning","Email/ Password tidak valid");
                                              controller.loading.value = false;
                                              controller.update();
                                            }
                                          } else {
                                            controller.update();
                                          }
                                        },
                                        text: "Kirim",
                                      ),
                                    ),
                                    const SizedBox(height: 40),
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
