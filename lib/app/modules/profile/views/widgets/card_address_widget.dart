import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAddressWidget extends GetView<ProfileController> {
  final int index;
  const CardAddressWidget(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: (index == 0) ? 16 : 0,
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 16, top: 0, right: 0, bottom: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: Get.width,
          decoration: BoxDecoration(
            border: Border.all(color: colorDiver),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text:
                            "${controller.userModel.addresses![index].firstName} ${controller.userModel.addresses![index].lastName}",
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      (controller.userModel.defaultAddress!.id ==
                              controller.userModel.addresses![index].id)
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF212121).withOpacity(0.1),
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(2)),
                              child: const CustomText(
                                text: "Utama",
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  IconButton(
                      onPressed: () => bottomSheet(index),
                      icon: const Icon(
                        Icons.more_vert,
                        size: 24,
                      ))
                ],
              ),
              CustomText(
                text: controller.userModel.addresses![index].phone ?? "",
                fontSize: 12,
              ),
              CustomText(
                text: controller.userModel.addresses![index].address1 ?? "",
                fontSize: 12,
              ),
              CustomText(
                text: controller.userModel.addresses![index].address2 ?? "",
                fontSize: 12,
              ),
              CustomText(
                text: controller.userModel.addresses![index].city ?? "",
                fontSize: 12,
              ),
              CustomText(
                text:
                    "${controller.userModel.addresses![index].province ?? ""}, ${controller.userModel.addresses![index].zip ?? ""}",
                fontSize: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void bottomSheet(index) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: Get.height * .35,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                    )),
                const CustomText(
                  text: "Pilih Aksi",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 20),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                controller.updateDefaultAddress(
                    controller.userModel.addresses![index].id!);
                Get.back();
              },
              child: const CustomText(
                text: "Jadikan alamat utama",
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                Get.back();
                Get.to(AddressForm(
                    controller.userModel.addresses![index].id, false));
              },
              child: const CustomText(
                text: "Edit alamat",
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                controller
                    .deleteAddress(controller.userModel.addresses![index].id!);
                Get.back();
              },
              child: const CustomText(
                text: "Hapus alamat",
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: false,
    );
  }
}
