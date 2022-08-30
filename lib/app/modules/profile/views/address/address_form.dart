import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/city_bottomsheet.dart';
import 'package:colorbox/app/modules/profile/views/address/kecamatan_bottomsheet.dart';
import 'package:colorbox/app/modules/profile/views/address/province_bottomsheet.dart';
import 'package:colorbox/app/modules/profile/views/address/zip_bottomsheet.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddressForm extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddressForm(this.id, this.checkout, {Key? key}) : super(key: key);
  final String? id;
  final bool checkout;

  final TextEditingController _namaLengkap = TextEditingController();
  final TextEditingController _telpon = TextEditingController();
  final TextEditingController _address1 = TextEditingController();
  final TextEditingController _province = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _address2 = TextEditingController();
  final TextEditingController _zip = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      var x = controller.userModel.addresses!.firstWhere((e) => e.id == id);

      _namaLengkap.text = x.firstName! + " " + x.lastName!;
      _telpon.text = x.phone!.replaceAll("+62", "");
      _address1.text = x.address1!;
      _province.text = x.province!;
      _city.text = x.city!;
      _address2.text = x.address2!;
      _zip.text = x.zip!;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: (id == null) ? "Tambah Alamat" : "Ubah Alamat",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.close)),
      ),
      backgroundColor: Colors.white,
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
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
        width: Get.width,
        child: CustomButton(
          onPressed: () async {
            _formKey.currentState!.save();

            if (_formKey.currentState!.validate()) {
              int result = await controller.saveAddress(id);

              if (result == 1) {
                await controller.getAddress();
                if (checkout) {
                  Get.offNamed(Routes.CHECKOUT);
                } else {
                  Get.back();
                }
                Get.snackbar(
                  "Info",
                  "Alamat berhasil " + ((id == null) ? "disimpan" : "diubah"),
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  "Info",
                  "Mohon Coba Lagi",
                  backgroundColor: Colors.black87,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }
          },
          text: "Simpan",
          width: Get.width,
          height: 60,
          color: Colors.white,
          backgroundColor: Colors.black,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: GetBuilder(
            init: Get.put(ProfileController()),
            builder: (c) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Kontak",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                              textEditingController: _namaLengkap,
                              onSave: (value) {
                                controller.address!.firstName = value;
                              },
                              onChange: (_) => controller.update(),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "tidak boleh kosong";
                                }
                                return null;
                              },
                              hint: "Nama Penerima"),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                            textEditingController: _telpon,
                            textInputType: TextInputType.phone,
                            onSave: (value) {
                              controller.address!.phone = "+62" + value!;
                            },
                            onChange: (_) => controller.update(),
                            validator: (input) {
                              if (input == null || input.length < 4) {
                                return "This field requires a minimum of 4 numbers";
                              }
                              return null;
                            },
                            hint: "Nomor Telepon",
                            prefix: const CustomText(
                              text: "+62",
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 8,
                      color: const Color(0xFFF9F8F8),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Alamat",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextFormField(
                            textEditingController: _address1,
                            textInputType: TextInputType.multiline,
                            onSave: (value) {
                              controller.address!.address1 = value;
                            },
                            onChange: (_) => controller.update(),
                            validator: (value) {
                              if (value == null || value == "") {
                                return "tidak boleh kosong";
                              }
                              return null;
                            },
                            hint: "Alamat",
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () => bottomSheetProvince(_province, _city),
                            child: TextFormField(
                              controller: _province,
                              onSaved: (value) {
                                controller.address!.province = value;
                              },
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "tidak boleh kosong";
                                }
                                return null;
                              },
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: "Provinsi",
                                labelStyle: const TextStyle(fontSize: 14),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    borderSide: BorderSide(
                                      color: (_zip.text.isNotEmpty)
                                          ? Colors.black
                                          : const Color(0xFFE5E8EB),
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: (_province.text == "")
                                ? null
                                : () async {
                                    await controller
                                        .fetchingCity(_province.text);
                                    bottomSheetCity(_city, _address2);
                                  },
                            child: TextFormField(
                              controller: _city,
                              onSaved: (value) {
                                controller.address!.city = value;
                              },
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "tidak boleh kosong";
                                }
                                return null;
                              },
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: "Kota",
                                labelStyle: const TextStyle(fontSize: 14),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    borderSide: BorderSide(
                                      color: (_zip.text.isNotEmpty)
                                          ? Colors.black
                                          : const Color(0xFFE5E8EB),
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: (_city.text == "")
                                ? null
                                : () async {
                                    await controller
                                        .fetchingKecamatan(_city.text);
                                    bottomSheetKecamatan(_address2, _zip);
                                  },
                            child: TextFormField(
                              controller: _address2,
                              onSaved: (value) {
                                controller.address!.address2 = value;
                              },
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "tidak boleh kosong";
                                }
                                return null;
                              },
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: "Kecamatan",
                                labelStyle: const TextStyle(fontSize: 14),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    borderSide: BorderSide(
                                      color: (_zip.text.isNotEmpty)
                                          ? Colors.black
                                          : const Color(0xFFE5E8EB),
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: (_address2.text == "")
                                ? null
                                : () async {
                                    await controller
                                        .fetchingKodePos(_address2.text);
                                    bottomSheetZip(_zip);
                                  },
                            child: TextFormField(
                              controller: _zip,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                controller.address!.zip = value;
                              },
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "tidak boleh kosong";
                                }
                                return null;
                              },
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: "Kode Pos",
                                labelStyle: const TextStyle(fontSize: 14),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    borderSide: BorderSide(
                                      color: (_zip.text.isNotEmpty)
                                          ? Colors.black
                                          : const Color(0xFFE5E8EB),
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      )),
    );
  }
}
