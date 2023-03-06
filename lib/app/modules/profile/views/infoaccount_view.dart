import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class InformationAccount extends StatelessWidget {
  ProfileController controller = Get.put(ProfileController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InformationAccount({Key? key}) : super(key: key);

  TextEditingController namaTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController birthdayTextController = TextEditingController();
  final TextEditingController _telpon = TextEditingController();
  bool telpAlert = false;

  @override
  Widget build(BuildContext context) {
    SettingsController _settingController = Get.find<SettingsController>();
    namaTextController.text = _settingController.userModel.displayName!;
    emailTextController.text = _settingController.userModel.email!;
    _telpon.text =
        (_settingController.userModel.phone ?? "").replaceAll("+62", "");

    DateTime _initialDate = controller.showDateBirth!;
    if (_settingController.userModel.note != null) {
      dynamic birthday = _settingController.userModel.note!.split("\n");
      for (int i = 0; i < birthday.length; i++) {
        if (birthday[i].toString().toLowerCase().contains("birthday")) {
          dynamic dt = DateTime.parse(
              birthday[i].toLowerCase().replaceAll("birthday: ", "").trim());
          birthdayTextController.text = DateFormat('dd/MM/yyyy').format(dt);

          _initialDate = dt;
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Informasi Akun",
          )),
      backgroundColor: Colors.white,
      body: GetBuilder(
          init: Get.put(ProfileController()),
          builder: (c) {
            return SafeArea(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: (controller.loading.value)
                      ? loadingCircular()
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                textEditingController: namaTextController,
                                hint: "Nama",
                                onChange: (value) => controller.update(),
                                onSave: (value) => controller.firstName = value,
                                validator: (value) {
                                  if (value == "" || value == null) {
                                    return "Nama tidak boleh kosong";
                                  }
                                  return null;
                                },
                                suffixIcon: (namaTextController.text.isNotEmpty)
                                    ? IconButton(
                                        onPressed: () {
                                          namaTextController.text = "";
                                          controller.update();
                                        },
                                        icon: const Icon(
                                          Icons.cancel_sharp,
                                          color: colorTextBlack,
                                          size: 18,
                                        ))
                                    : const SizedBox(),
                              ),
                              const SizedBox(height: 24),
                              CustomTextFormField(
                                textEditingController: emailTextController,
                                hint: "Email",
                                onChange: (value) => controller.update(),
                                onSave: (value) => controller.email = value,
                                validator: (value) {
                                  if (RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value!)) {
                                    return null;
                                  }
                                  return "Format email salah";
                                },
                                suffixIcon:
                                    (emailTextController.text.isNotEmpty)
                                        ? IconButton(
                                            onPressed: () {
                                              emailTextController.text = "";
                                              controller.update();
                                            },
                                            icon: const Icon(
                                              Icons.cancel_sharp,
                                              color: colorTextBlack,
                                              size: 18,
                                            ))
                                        : const SizedBox(),
                              ),
                              const SizedBox(height: 24),
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
                                    return "Minimum karakter 8";
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
                                height: 24,
                              ),
                              InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  showDatePicker(
                                    helpText: "Pilih Tanggal",
                                    confirmText: "Pilih",
                                    cancelText: "Batal",
                                    context: context,
                                    initialDate: _initialDate,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2025),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary:
                                                colorTextBlack, // <-- SEE HERE
                                            onPrimary:
                                                Colors.white, // <-- SEE HERE
                                            onSurface:
                                                colorTextBlack, // <-- SEE HERE
                                          ),
                                          textButtonTheme: TextButtonThemeData(
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
                                    return birthdayTextController.text =
                                        DateFormat('dd/MM/yyyy').format(value!);
                                  });
                                },
                                child: TextFormField(
                                  cursorColor: colorTextBlack,
                                  enabled: false,
                                  controller: birthdayTextController,
                                  onChanged: (_) => controller.update(),
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    labelText: "Tanggal Lahir",
                                    suffixIcon: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.calendar_today,
                                        color: colorTextBlack,
                                        size: 18,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                        borderSide: BorderSide(
                                          color: (birthdayTextController
                                                  .text.isNotEmpty)
                                              ? colorTextBlack
                                              : const Color(0xFFE5E8EB),
                                          width: 1.0,
                                        )),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                        borderSide: BorderSide(
                                          color: (birthdayTextController
                                                  .text.isNotEmpty)
                                              ? colorTextBlack
                                              : const Color(0xFFE5E8EB),
                                          width: 1.0,
                                        )),
                                  ),
                                  onSaved: (value) {
                                    controller.tglLahir = value;
                                  },
                                  // obscureText: test,
                                  validator: (value) {
                                    if (value == "" || value == null) {
                                      return "Tgl. Lahir tidak boleh kosong";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset:
                            const Offset(0, -5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CustomButton(
                    onPressed: () async {
                      _formKey.currentState!.save();

                      if (_formKey.currentState!.validate()) {
                        await controller.customerUpdate();
                        await _settingController.getUser();
                      }
                    },
                    text: "Simpan",
                    color: Colors.white,
                    backgroundColor: colorTextBlack,
                  ),
                ),
              ],
            ));
          }),
    );
  }
}
