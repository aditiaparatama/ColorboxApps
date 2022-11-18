import 'package:colorbox/app/modules/profile/views/profile_view.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class RegisterView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController birthday = TextEditingController();
  final TextEditingController _telpon = TextEditingController();
  FocusNode emailFocus = FocusNode();

  static const str = 'date: 2019:04:01';
  final valuestest = str.split(': ');
  bool emailAlert = false, namaAlert = false, telpAlert = false;

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 320,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    "assets/icon/Email-Registered-Illustration.svg"),
                const SizedBox(height: 8),
                const CustomText(
                  text: "Email Sudah Terdaftar",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomText(
                  text: "Alamat email '${controller.email}' sudah terdaftar",
                  textOverflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: () {
                    Get.back();
                    Get.to(ProfileView("onboard"));
                  },
                  text: "Masuk akun",
                  backgroundColor: colorTextBlack,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  onPressed: () => Get.back(),
                  text: "Kembali",
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: AppBarDefault(
              text: "Daftar Akun",
            )),
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
                            const SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextFormField(
                                      hint: "Email",
                                      showAlert: emailAlert,
                                      onSave: (value) {
                                        controller.email = value;
                                      },
                                      validator: (value) {
                                        if (value == "" || value == null) {
                                          emailAlert = true;
                                          return "Email wajib diisi";
                                        }
                                        if (RegExp(
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                            .hasMatch(value!)) {
                                          emailAlert = false;
                                          return null;
                                        }
                                        emailAlert = true;
                                        return "Format email salah";
                                      },
                                      focusNode: emailFocus,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      cursorColor: colorTextBlack,
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
                                            color: colorTextBlack,
                                          ),
                                        ),
                                      ),
                                      obscureText: controller.showPassword!,
                                      onSaved: (value) {
                                        controller.password = value;
                                      },
                                      validator: (value) {
                                        if (value == "" || value == null) {
                                          return "Password wajib diisi";
                                        }
                                        if (value.length < 6) {
                                          return "Password minimal 6 karakter";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomTextFormField(
                                      hint: "Nama Lengkap",
                                      showAlert: namaAlert,
                                      onSave: (value) {
                                        controller.firstName = value;
                                      },
                                      validator: (value) {
                                        if (value == "" || value == null) {
                                          namaAlert = true;
                                          return "Nama wajib diisi";
                                        }
                                        namaAlert = false;
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomTextFormField(
                                      textEditingController: _telpon,
                                      showAlert: telpAlert,
                                      textInputType: TextInputType.phone,
                                      onSave: (value) {
                                        controller.noTelp = "+62" + value!;
                                      },
                                      onChange: (_) => controller.update(),
                                      validator: (input) {
                                        if (input == null || input.length < 8) {
                                          telpAlert = true;
                                          return "This field requires a minimum of 8 numbers";
                                        }
                                        telpAlert = false;
                                        return null;
                                      },
                                      hint: "Nomor Telepon",
                                      prefix: const CustomText(
                                        text: "+62",
                                        fontSize: 14,
                                      ),
                                      suffixIcon: (_telpon.text.isNotEmpty)
                                          ? IconButton(
                                              onPressed: () {
                                                _telpon.text = "";
                                                controller.update();
                                              },
                                              icon: const Icon(
                                                Icons.cancel_sharp,
                                                color: colorTextBlack,
                                                size: 18,
                                              ))
                                          : const SizedBox(),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    InkWell(
                                      onTap: () => showDatePicker(
                                        helpText: "Pilih Tanggal",
                                        confirmText: "Pilih",
                                        cancelText: "Batal",
                                        context: context,
                                        initialDate: controller.showDateBirth!,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2025),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Colors
                                                    .black, // <-- SEE HERE
                                                onPrimary: Colors
                                                    .white, // <-- SEE HERE
                                                onSurface: Colors
                                                    .black, // <-- SEE HERE
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                    foregroundColor: Colors
                                                        .white, // button text color
                                                    side: const BorderSide(
                                                        color: colorTextBlack,
                                                        width: 1),
                                                    backgroundColor:
                                                        colorTextBlack),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      ).then((value) {
                                        return birthday.text =
                                            DateFormat('dd/MM/yyyy')
                                                .format(value!);
                                      }),
                                      child: TextFormField(
                                        cursorColor: colorTextBlack,
                                        enabled: false,
                                        controller: birthday,
                                        decoration: InputDecoration(
                                          labelText: "Tanggal Lahir",
                                          suffixIcon: GestureDetector(
                                            onTap: () {},
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
                                          if (value == "" || value == null) {
                                            return "Tgl. Lahir wajib diisi";
                                          }
                                          return null;
                                        },
                                      ),
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
                                              Get.offAllNamed(Routes.CONTROLV2);
                                            } else {
                                              if (result ==
                                                      "Email sudah diambil" ||
                                                  result ==
                                                      "Email has already been taken") {
                                                _showMyDialog(context);
                                              }
                                              controller.loading.value = false;
                                              controller.update();
                                            }
                                          } else {
                                            controller.update();
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
                                                  child: Image.asset(
                                                    "assets/icon/google-icon.png",
                                                    height: 28,
                                                    width: 28,
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
