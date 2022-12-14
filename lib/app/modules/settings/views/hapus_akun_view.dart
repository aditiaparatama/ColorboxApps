import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/modules/settings/views/hapus_akun_notice.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_checkout.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HapusAkunView extends GetView<SettingsController> {
  HapusAkunView({Key? key}) : super(key: key);
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _lainnyaText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool _option1 = false;
    bool _option2 = false;
    bool _option3 = false;
    bool _option4 = false;
    List<String> _reason = [];

    _emailText.text = controller.userModel.email!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Pengajuan Hapus Akun",
          )),
      body: GetBuilder<SettingsController>(builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text:
                            "Kamu hendak mengajukan penghapusan akun Colorbox. Dengan menghapus akun Colorbox, email kamu akan tidak dapat digunakan dan beberapa data transaksi di Colorbox akan dihapus.",
                        textOverflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 16),
                      const CustomText(
                        text:
                            'Silahkan isi form berikut ini untuk melanjutkan penghapusan akun :',
                        textOverflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        onSave: (value) {},
                        validator: (value) {},
                        hint: 'Email',
                        textEditingController: _emailText,
                        readOnly: true,
                      ),
                      const SizedBox(height: 24),
                      const CustomText(
                        text: "Alasan hapus akun",
                      ),
                      const SizedBox(height: 16),
                      CustomCheckbox(
                        value: _option1,
                        text: "Saya tidak tertarik dengan produk Colorbox",
                        onChange: (value) {
                          _option1 = value!;
                          if (value) {
                            _reason.add(
                                "Saya tidak tertarik dengan produk Colorbox");
                          } else {
                            _reason.removeWhere((element) =>
                                element ==
                                "Saya tidak tertarik dengan produk Colorbox");
                          }
                          controller.update();
                        },
                      ),
                      CustomCheckbox(
                        value: _option2,
                        text: "Aplikasi ini tidak menjawab kebutuhan saya",
                        onChange: (value) {
                          _option2 = value!;
                          if (value) {
                            _reason.add(
                                "Aplikasi ini tidak menjawab kebutuhan saya");
                          } else {
                            _reason.removeWhere((element) =>
                                element ==
                                "Aplikasi ini tidak menjawab kebutuhan saya");
                          }
                          controller.update();
                        },
                      ),
                      CustomCheckbox(
                        value: _option3,
                        text: "Promo yang ditawarkan kurang menarik",
                        onChange: (value) {
                          _option3 = value!;
                          if (value) {
                            _reason.add("Promo yang ditawarkan kurang menarik");
                          } else {
                            _reason.removeWhere((element) =>
                                element ==
                                "Promo yang ditawarkan kurang menarik");
                          }
                          controller.update();
                        },
                      ),
                      CustomCheckbox(
                        value: _option4,
                        text: "Lainnya",
                        onChange: (value) {
                          _option4 = value!;
                          controller.update();
                        },
                      ),
                      if (_option4)
                        TextFormField(
                          minLines: 4,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Masukan alasan lainnya",
                          ),
                          cursorColor: colorTextBlack,
                          controller: _lainnyaText,
                          onSaved: (value) {
                            _lainnyaText.text = value!;
                          },
                          validator: (value) {
                            return null;
                          },
                        ),
                      const SizedBox(height: 40),
                      CustomButton(
                        onPressed: () {
                          if (_lainnyaText.text != "") {
                            _reason.add(_lainnyaText.text);
                          }
                          controller.deleteAccount(
                              '{"email" : "${_emailText.text}", "reason" : "${_reason.toString()}"}');
                          Get.off(const HapusAkunNotice());
                        },
                        text: "Ajukan Hapus Akun",
                        color: Colors.white,
                        backgroundColor: colorTextBlack,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
