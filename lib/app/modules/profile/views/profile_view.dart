import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class ProfileView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  final globalKey;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  bool showAlert = false;

  ProfileView(this.globalKey, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: AppBarDefault(
              text: "Masuk Akun",
            )),
        backgroundColor: Colors.white,
        body: GetBuilder(
            init: Get.put(ProfileController()),
            builder: (c) {
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
                                const SizedBox(height: 24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextFormField(
                                            textEditingController:
                                                emailController,
                                            hint: "Email",
                                            onSave: (value) {
                                              controller.email = value;
                                            },
                                            onChange: (_) =>
                                                controller.update(),
                                            validator: (value) {
                                              if (RegExp(
                                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                  .hasMatch(value!)) {
                                                return null;
                                              }
                                              FocusScope.of(context)
                                                  .requestFocus(emailFocus);
                                              return "Format email salah";
                                            },
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: showAlert
                                                  ? SvgPicture.asset(
                                                      "assets/icon/circle-exclamation-solid.svg",
                                                    )
                                                  : null,
                                            )),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        CustomTextFormField(
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              controller.togglevisibility();
                                            },
                                            child: Icon(
                                              !controller.showPassword!
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: colorTextBlack,
                                            ),
                                          ),
                                          hint: "Password",
                                          textEditingController:
                                              passwordController,
                                          obscureText: controller.showPassword!,
                                          onChange: (_) => controller.update(),
                                          onSave: (value) {
                                            controller.password = value;
                                          },
                                          validator: (value) {
                                            if (value == null || value == "") {
                                              return "Password tidak boleh kosong";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        InkWell(
                                          onTap: () => Get.toNamed(
                                              Routes.FORGOTPASSWORD),
                                          child: const SizedBox(
                                            child: Text(
                                              'Lupa Password?',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF115AC8)),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: CustomButton(
                                            backgroundColor: colorTextBlack,
                                            color: secondColor,
                                            onPressed: () async {
                                              _formKey.currentState!.save();

                                              if (_formKey.currentState!
                                                  .validate()) {
                                                var result =
                                                    await controller.login();
                                                if (result == "1") {
                                                  await Get.find<
                                                          SettingsController>()
                                                      .fetchingUser();

                                                  if (globalKey == "onboard") {
                                                    return Get.offAllNamed(
                                                        Routes.CONTROLV2);
                                                  }
                                                  if (globalKey != null) {
                                                    final BottomNavigationBar
                                                        navigationBar =
                                                        globalKey.currentWidget;
                                                    navigationBar.onTap!(2);
                                                  } else {
                                                    Get.back();
                                                  }
                                                } else {
                                                  Get.snackbar("", result,
                                                      titleText: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icon/Exclamation-Circle.svg",
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          const CustomText(
                                                            text:
                                                                "Terjadi Kesalahan",
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          colorTextBlack,
                                                      colorText: Colors.white,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM);
                                                }
                                              } else {
                                                showAlert = true;
                                                controller.update();
                                              }
                                            },
                                            text: "Masuk",
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const CustomText(
                                                  text: 'Belum punya akun?',
                                                  fontSize: 12,
                                                  color: colorTextBlack,
                                                ),
                                                GestureDetector(
                                                  onTap: (controller
                                                          .loading.value)
                                                      ? null
                                                      : () => (globalKey ==
                                                              null)
                                                          ? Get.offNamed(
                                                              Routes.REGISTER)
                                                          : Get.toNamed(
                                                              Routes.REGISTER),
                                                  child: const CustomText(
                                                    text: " Daftar sekarang",
                                                    fontSize: 12,
                                                    color: Color(0xFF115AC8),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              ]),
                                        ]),
                                        const SizedBox(height: 40),
                                        Column(children: [
                                          Row(children: [
                                            Expanded(
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10.0, right: 20.0),
                                                  child: const Divider(
                                                    color: colorBorderGrey,
                                                    height: 36,
                                                  )),
                                            ),
                                            const Text("Atau"),
                                            Expanded(
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, right: 10.0),
                                                  child: const Divider(
                                                    color: colorBorderGrey,
                                                    height: 36,
                                                  )),
                                            ),
                                          ]),
                                        ]),
                                        const SizedBox(height: 40),
                                        CustomButton(
                                            onPressed: () {},
                                            borderColor: colorBorderGrey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Image.asset(
                                                    "assets/icon/google-icon.png",
                                                  ),
                                                ),
                                                const CustomText(
                                                  text:
                                                      "Lanjutkan dengan Google",
                                                  color: colorTextBlack,
                                                ),
                                              ],
                                            )),
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
