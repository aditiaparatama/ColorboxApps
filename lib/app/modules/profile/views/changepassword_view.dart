import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
// import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class ChangePasswordView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController birthday = TextEditingController();

  static const str = 'date: 2019:04:01';
  final valuestest = str.split(': ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const CustomText(
            text: 'Daftar Akun',
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
                                    CustomTextFormField(
                                      hint: "Email",
                                      onSave: (value) {
                                        controller.email = value;
                                      },
                                      validator: (value) {
                                        if (RegExp(
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                            .hasMatch(value!)) {
                                          return null;
                                        }
                                        return "Format email salah";
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      hint: "Password",
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          controller.togglevisibility();
                                        },
                                        child: Icon(
                                          controller.showPassword!
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: colorTextBlack,
                                        ),
                                      ),
                                      obscureText: controller.showPassword!,
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
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      hint: "Nama",
                                      onSave: (value) {
                                        controller.firstName = value;
                                      },
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "Nama tidak boleh kosong";
                                        }
                                        return "";
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: birthday,
                                      decoration: InputDecoration(
                                        labelText: "Tanggal Lahir",
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate:
                                                  controller.showDateBirth!,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2025),
                                            ).then((value) {
                                              return birthday.text =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(value!);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.calendar_today,
                                            color: colorTextBlack,
                                          ),
                                        ),
                                      ),
                                      onSaved: (value) {
                                        controller.tglLahir = value;
                                      },
                                      // obscureText: test,
                                      validator: (value) {
                                        if (value == null || value == "") {
                                          return "Tgl. Lahir tidak boleh kosong";
                                        }
                                        return "";
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
                                        text: "Daftar",
                                      ),
                                    ),
                                    const SizedBox(height: 40),
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
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: SizedBox(
                                        child: MaterialButton(
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
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
                                                    color: colorTextBlack,
                                                    fontSize: 14.0),
                                              ),
                                            ],
                                          ),
                                          onPressed: () =>
                                              Get.offNamed(Routes.REGISTER),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Column(children: <Widget>[
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const CustomText(
                                              text: 'Sudah punya akun?',
                                              fontSize: 13,
                                              color: colorTextBlack,
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Get.toNamed(Routes.PROFILE),
                                              child: const Text(
                                                'Masuk sekarang',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromRGBO(
                                                        17, 90, 200, 1)),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ]),
                                    ]),
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
