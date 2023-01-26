import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/city_bottomsheet.dart';
import 'package:colorbox/app/modules/profile/views/address/kecamatan_bottomsheet.dart';
import 'package:colorbox/app/modules/profile/views/address/province_bottomsheet.dart';
import 'package:colorbox/app/modules/profile/views/address/zip_bottomsheet.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddressForm extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddressForm(this.id, this.checkout, {Key? key}) : super(key: key);
  final String? id;
  final bool checkout;
  bool namaAlert = false, telpAlert = false, address1Alert = false;

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

      if (x.province != null && x.province != "") {
        controller.searchProvince(x.province!);
        // controller.update();
      }

      if (x.phone!.substring(0, 2) == "08") {
        x.phone = x.phone!.substring(1, x.phone!.length);
      }
      _namaLengkap.text = x.firstName! + " " + x.lastName!;
      _telpon.text = x.phone!.replaceAll("+62", "");
      _address1.text = x.address1 ?? "";
      _province.text = x.province ?? "";
      _city.text = x.city ?? "";
      _address2.text = x.address2 ?? "";
      _zip.text = x.zip!;
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarDefault(
            text: (id == null) ? "Tambah Alamat" : "Ubah Alamat",
            icon: const Icon(Icons.close),
          )),
      backgroundColor: Colors.white,
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
                            autoFocus: true,
                            textEditingController: _namaLengkap,
                            showAlert: namaAlert,
                            onSave: (value) {
                              controller.address!.firstName = value;
                            },
                            onChange: (_) => controller.update(),
                            validator: (value) {
                              if (value == null || value == "") {
                                namaAlert = true;
                                return "tidak boleh kosong";
                              }
                              namaAlert = false;
                              return null;
                            },
                            hint: "Nama Penerima",
                            suffixIcon: (_namaLengkap.text.isNotEmpty)
                                ? IconButton(
                                    onPressed: () {
                                      _namaLengkap.text = "";
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
                          CustomTextFormField(
                            textEditingController: _telpon,
                            showAlert: telpAlert,
                            textInputType: TextInputType.phone,
                            onSave: (value) {
                              controller.address!.phone = "+62" + value!;
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
                            showAlert: address1Alert,
                            textInputType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            onSave: (value) {
                              controller.address!.address1 = value;
                            },
                            onChange: (_) => controller.update(),
                            validator: (value) {
                              if (value == null || value == "") {
                                address1Alert = true;
                                return "tidak boleh kosong";
                              }
                              address1Alert = false;
                              return null;
                            },
                            hint: "Alamat",
                            suffixIcon: (_address1.text.isNotEmpty)
                                ? IconButton(
                                    onPressed: () {
                                      _address1.text = "";
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
                            onTap: () {
                              // FocusScope.of(context).requestFocus(FocusNode());
                              // TextInputAction.done;
                              bottomSheetProvince(_province, _city);
                            },
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
                                      color: (_province.text.isNotEmpty)
                                          ? colorTextBlack
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
                                      color: (_city.text.isNotEmpty)
                                          ? colorTextBlack
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
                                      color: (_address2.text.isNotEmpty)
                                          ? colorTextBlack
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
                                          ? colorTextBlack
                                          : const Color(0xFFE5E8EB),
                                      width: 1.0,
                                    )),
                              ),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(
                                0, -5), // changes position of shadow
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
                                Get.find<CartController>().update();
                                Get.offAndToNamed(Routes.CHECKOUT);
                              } else {
                                Get.back();
                              }
                              Get.snackbar(
                                  "",
                                  "Alamat berhasil " +
                                      ((id == null) ? "disimpan" : "diubah"),
                                  titleText: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icon/Check-Circle.svg",
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        text: "Berhasil",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  backgroundColor: colorTextBlack,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                            } else {
                              Get.snackbar("", "Mohon Coba Lagi",
                                  titleText: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icon/Exclamation-Circle.svg",
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      const CustomText(
                                        text: "Gagal",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  backgroundColor: colorTextBlack,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          } else {
                            controller.update();
                          }
                        },
                        text: "Simpan",
                        width: Get.width,
                        height: 60,
                        color: Colors.white,
                        backgroundColor: colorTextBlack,
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
