import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/modules/profile/views/widgets/card_address_widget.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddressView extends GetView<ProfileController> {
  const AddressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Ubah Alamat',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          TextButton(
              onPressed: () => Get.to(AddressForm(null, false)),
              child: const CustomText(
                text: "Tambah Alamat",
                color: Color(0xFF115AC8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ))
        ],
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: SafeArea(
          child: GetBuilder(
        init: Get.put(ProfileController()),
        builder: (c) {
          return (controller.userModel.displayName == null)
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : Stack(
                  children: [
                    ListView.builder(
                        itemCount: controller.userModel.addresses!.length,
                        itemBuilder: (_, index) {
                          return CardAddressWidget(index);
                        }),
                    (controller.loading.value)
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : const SizedBox()
                  ],
                );
        },
      )),
    );
  }
}