import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/widgets/custom_search_formtext.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void bottomSheetProvince(_province, _city) {
  ProfileController controller = Get.put(ProfileController());
  controller.resetProvince();
  Get.bottomSheet(
    Container(
      height: Get.height * .75,
      padding: const EdgeInsets.only(top: 27, right: 24, bottom: 0, left: 24),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: GetBuilder<ProfileController>(
          init: Get.put(ProfileController()),
          builder: (_) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                          )),
                      const SizedBox(width: 8),
                      const CustomText(
                        text: "Pilih Provinsi",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomSearchTextForm(
                    textHint: "Cari Provinsi",
                    onChanged: (value) {
                      controller.searchProvince(value);
                    },
                    onSaved: (value) {},
                    validator: (value) {
                      if (value != null || value != "") {
                        return "tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  (controller.province == null)
                      ? SizedBox(child: loadingCircular())
                      : SizedBox(
                          height: Get.height * .5,
                          width: Get.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (final x in controller.province!) ...[
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        fixedSize: Size(Get.width, 20),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      onPressed: () {
                                        _province.text = x.name!;
                                        _city.text = "";
                                        Get.back();
                                        controller.update();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: x.name!,
                                          ),
                                          (_province.text == x.name)
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                )
                                              : const SizedBox()
                                        ],
                                      )),
                                  const Divider(),
                                ],
                              ],
                            ),
                          ),
                        ),
                ]);
          }),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
