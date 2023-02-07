import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/widgets/custom_search_formtext.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void bottomSheetKecamatan(_address2, _zip) {
  ProfileController controller = Get.put(ProfileController());
  Get.bottomSheet(
    SafeArea(
      child: Container(
        height: Get.height * .75,
        padding:
            const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
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
                          text: "Pilih Kecamatan",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomSearchTextForm(
                      textHint: "Kecamatan",
                      onSaved: (value) {},
                      onChanged: (value) {
                        controller.searchWilayah(value, "kecamatan");
                      },
                      validator: (value) {
                        if (value != null || value != "") {
                          return "tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    (controller.kecamatan.length == 0)
                        ? const SizedBox(
                            child: Center(
                              child: CustomText(text: "Data not found"),
                            ),
                          )
                        : Expanded(
                            child: SizedBox(
                                width: Get.width,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (final x in controller.kecamatan) ...[
                                        InkWell(
                                            onTap: () {
                                              _address2.text = x;
                                              _zip.text = "";
                                              Get.back();
                                              controller.update();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: x,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        (_address2.text == x)
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                  (_address2.text == x)
                                                      ? const Icon(
                                                          Icons.check,
                                                          color: colorTextBlack,
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                            )),
                                        const Divider(),
                                      ]
                                    ],
                                  ),
                                )),
                          ),
                  ]);
            }),
      ),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
