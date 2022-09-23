import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/modules/profile/views/widgets/card_address_widget.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddressView extends GetView<ProfileController> {
  final bool fromDetail;
  const AddressView({Key? key, this.fromDetail = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarDefault(
            text: (fromDetail) ? 'Daftar Alamat' : 'Ubah Alamat',
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
          )),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: GetBuilder(
        init: Get.put(ProfileController()),
        builder: (c) {
          return (controller.userModel.displayName == null)
              ? const Center(
                  child: CircularProgressIndicator(color: colorTextBlack),
                )
              : (controller.userModel.addresses!.isEmpty)
                  ? EmptyPage(
                      image: Image.asset(
                        "assets/icon/MAPS.gif",
                        height: 180,
                      ),
                      textHeader: "Belum Ada Alamat",
                      textContent: "Belum ada daftar alamat yang tersimpan",
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
                                  color: colorTextBlack,
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
