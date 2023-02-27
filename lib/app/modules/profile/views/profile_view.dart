import 'dart:async';
import 'dart:io';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/app/widgets/pop_up_alert.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/utilities/extension.dart';
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
  bool emailAlert = false;
  AutovalidateMode emailValidate = AutovalidateMode.disabled;
  AutovalidateMode passwordValidate = AutovalidateMode.disabled;
  Timer? _debounce;

  void _triggerValidator(String name) {
    switch (name) {
      case "email":
        emailValidate = AutovalidateMode.always;
        break;
      case "pass":
        passwordValidate = AutovalidateMode.always;
        break;
      default:
        break;
    }
    controller.update();
  }

  ProfileView(this.globalKey, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarDefault(
              text: "Masuk Akun",
              leadingActive: (globalKey is LabeledGlobalKey) ? false : true,
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
                                          autoFocus: true,
                                          autovalidateMode: emailValidate,
                                          textInputAction: TextInputAction.next,
                                          showAlert: emailAlert,
                                          onSave: (value) {
                                            controller.email = value;
                                          },
                                          onChange: (value) async {
                                            if (StringExtention(value)
                                                .isValidEmail()) {
                                              if (_debounce?.isActive ??
                                                  false) {
                                                _debounce?.cancel();
                                              }
                                              _debounce = Timer(
                                                  const Duration(
                                                      milliseconds: 300),
                                                  () async {
                                                // do something with query
                                                await controller
                                                    .checkEmail(value);
                                              });
                                            }
                                            controller.update();
                                          },
                                          validator: (value) {
                                            if (StringExtention(value)
                                                .isValidEmail()) {
                                              if (!controller.emailExist!) {
                                                emailAlert = true;
                                                return "Email belum terdaftar";
                                              }
                                              emailAlert = false;
                                              return null;
                                            }
                                            emailAlert = true;
                                            return "Format email salah";
                                          },
                                          onFieldSubmitted: (value) {
                                            if (!controller.emailExist!) {
                                              emailAlert = true;
                                            }
                                            _triggerValidator("email");
                                          },
                                        ),
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
                                          autovalidateMode: passwordValidate,
                                          textInputAction: TextInputAction.go,
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
                                          onTap: () {
                                            if (!controller.emailExist!) {
                                              emailAlert = true;
                                            }
                                            _triggerValidator("email");
                                          },
                                          onFieldSubmitted: (value) =>
                                              _triggerValidator("pass"),
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
                                            onPressed: (controller
                                                    .loading.value)
                                                ? null
                                                : () async {
                                                    _formKey.currentState!
                                                        .save();

                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      var result =
                                                          await controller
                                                              .login();
                                                      if (result == "1") {
                                                        await Get.find<
                                                                SettingsController>()
                                                            .fetchingUser();

                                                        if (globalKey ==
                                                            "onboard") {
                                                          return Get.offAllNamed(
                                                              Routes.CONTROLV2);
                                                        }
                                                        if (globalKey != null) {
                                                          final BottomNavigationBar
                                                              navigationBar =
                                                              globalKey
                                                                  .currentWidget;
                                                          navigationBar
                                                              .onTap!(2);
                                                        } else {
                                                          Get.back();
                                                        }
                                                      } else {
                                                        await popUpAlert(
                                                            context,
                                                            "Terjadi Kesalahan",
                                                            CustomText(
                                                              text: result,
                                                              fontSize: 12,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            () => Get.back());
                                                      }
                                                    } else {
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
                                        if (Platform.isIOS)
                                          CustomButton(
                                              onPressed: () async {
                                                String result = await controller
                                                    .loginWithApple();
                                                if (result != "-1") {
                                                  await Get.find<
                                                          SettingsController>()
                                                      .fetchingUser(id: result);

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
                                                }
                                              },
                                              borderColor: colorBorderGrey,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: SvgPicture.asset(
                                                      "assets/icon/login/icon-apple.svg",
                                                    ),
                                                  ),
                                                  const CustomText(
                                                    text:
                                                        "Lanjutkan dengan Apple",
                                                    color: colorTextBlack,
                                                  ),
                                                ],
                                              )),
                                        const SizedBox(height: 16),
                                        CustomButton(
                                            onPressed: () async {
                                              String result = await controller
                                                  .loginWithGoogle();

                                              if (result == "-1") {
                                                controller.loading.value =
                                                    false;
                                                controller.update();
                                              }
                                              if (result != "-1") {
                                                await Get.find<
                                                        SettingsController>()
                                                    .fetchingUser(id: result);

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
                                              }
                                            },
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
                      ? Container(
                          color: colorOverlay.withOpacity(0.2),
                          height: Get.height,
                          width: Get.width,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: Colors.grey,
                          )),
                        )
                      : const SizedBox()
                ],
              );
            }));
  }
}
