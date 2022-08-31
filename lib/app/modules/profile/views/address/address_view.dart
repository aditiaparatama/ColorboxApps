import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/modules/profile/views/widgets/card_address_widget.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddressView extends GetView<ProfileController> {
  final bool fromDetail;
  const AddressView({Key? key, this.fromDetail = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: (fromDetail) ? 'Daftar Alamat' : 'Ubah Alamat',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
                onPressed: () => Get.to(AddressForm(null, false)),
                child: const CustomText(
                  text: "Tambah Alamat",
                  color: Color(0xFF115AC8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
          )
        ],
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        leadingWidth: 36,
        leading: IconButton(
            padding: const EdgeInsets.all(16),
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back)),
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
                          return InkWell(
                              onTap: (fromDetail)
                                  ? null
                                  : () {
                                      Get.find<CheckoutController>()
                                          .updateShippingAddress(controller
                                              .userModel.addresses![index]);
                                      Get.back();
                                    },
                              child: CardAddressWidget(index));
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
