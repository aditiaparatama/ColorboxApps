import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
// import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class ProfileView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  final globalKey;
  FocusNode emailFocus = FocusNode();
  ProfileView(this.globalKey, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "Masuk Akun",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
          elevation: 3,
          shadowColor: Colors.grey.withOpacity(0.3),
        ),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, right: 20, left: 20),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          cursorColor: Colors.black,
                                          decoration: const InputDecoration(
                                            labelText: "Email",
                                          ),
                                          onSaved: (value) {
                                            controller.email = value;
                                          },
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
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            labelText: "Password",
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                controller.togglevisibility();
                                              },
                                              child: Icon(
                                                !controller.showPassword!
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          obscureText: controller.showPassword!,
                                          onSaved: (value) {
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
                                          height: 0,
                                        ),
                                        TextButton(
                                          onPressed: () => Get.toNamed(
                                              Routes.FORGOTPASSWORD),
                                          child: const Text(
                                            'Lupa Password?',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    17, 90, 200, 1)),
                                            textAlign: TextAlign.left,
                                          ),
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
                                                  await Get.find<
                                                          SettingsController>()
                                                      .fetchingUser();
                                                  if (globalKey != null) {
                                                    final BottomNavigationBar
                                                        navigationBar =
                                                        globalKey.currentWidget;
                                                    navigationBar.onTap!(2);
                                                  } else {
                                                    Get.back();
                                                  }
                                                } else {
                                                  Get.snackbar(
                                                      "Warning", result,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM);
                                                }
                                              }
                                            },
                                            text: "Masuk",
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Column(children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const CustomText(
                                                  text: 'Belum punya akun?',
                                                  fontSize: 13,
                                                  color: Colors.black,
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
                                                    text: "Daftar sekarang",
                                                    fontSize: 12,
                                                    color: Color(0xFF115AC8),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              ]),
                                        ]),
                                        const SizedBox(height: 20),
                                        Column(children: <Widget>[
                                          Row(children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10.0, right: 20.0),
                                                  child: const Divider(
                                                    color: Colors.grey,
                                                    height: 36,
                                                  )),
                                            ),
                                            const Text("Atau"),
                                            Expanded(
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20.0, right: 10.0),
                                                  child: const Divider(
                                                    color: Colors.grey,
                                                    height: 36,
                                                  )),
                                            ),
                                          ]),
                                        ]),
                                        const SizedBox(height: 40),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: SizedBox(
                                            child: MaterialButton(
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0,
                                                            right: 10,
                                                            left: 30),
                                                    child: CircleAvatar(
                                                      child: SvgPicture.asset(
                                                        "assets/icon/bx-gnew.svg",
                                                        height: 40.0,
                                                        width: 40.0,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Lanjutkan dengan Google",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () =>
                                                  Get.offNamed(Routes.REGISTER),
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
