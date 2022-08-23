import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/app/widgets/widget.dart';
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

  @override
  Widget build(BuildContext context) {
    SettingsController _settingController = Get.find<SettingsController>();
    namaTextController.text = _settingController.userModel.displayName!;
    emailTextController.text = _settingController.userModel.email!;
    birthdayTextController.text = (_settingController.userModel.note != null)
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(_settingController.userModel.note!.trim()))
        : "";

    DateTime _initialDate = (_settingController.userModel.note != null)
        ? DateTime.parse(_settingController.userModel.note!.trim())
        : controller.showDateBirth!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(
          text: "Informasi Akun",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 7), // changes position of shadow
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
          backgroundColor: Colors.black,
        ),
      ),
      body: GetBuilder(
          init: Get.put(ProfileController()),
          builder: (c) {
            return SafeArea(
                child: Container(
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
                                      color: Colors.black,
                                      size: 18,
                                    ))
                                : const SizedBox(),
                          ),
                          const SizedBox(height: 16),
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
                            suffixIcon: (emailTextController.text.isNotEmpty)
                                ? IconButton(
                                    onPressed: () {
                                      emailTextController.text = "";
                                      controller.update();
                                    },
                                    icon: const Icon(
                                      Icons.cancel_sharp,
                                      color: Colors.black,
                                      size: 18,
                                    ))
                                : const SizedBox(),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () => showDatePicker(
                              helpText: "Pilih Tanggal",
                              confirmText: "Pilih",
                              cancelText: "Batal",
                              context: context,
                              initialDate: _initialDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2025),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.black, // <-- SEE HERE
                                      onPrimary: Colors.white, // <-- SEE HERE
                                      onSurface: Colors.black, // <-- SEE HERE
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                          primary:
                                              Colors.white, // button text color
                                          side: const BorderSide(
                                              color: Colors.black, width: 1),
                                          backgroundColor: Colors.black),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((value) {
                              return birthdayTextController.text =
                                  DateFormat('dd/MM/yyyy').format(value!);
                            }),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              enabled: false,
                              controller: birthdayTextController,
                              decoration: InputDecoration(
                                labelText: "Tanggal Lahir",
                                suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                  ),
                                ),
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
            ));
          }),
    );
  }
}
