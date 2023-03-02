import 'dart:async';

import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/widgets/custom_search_formtext.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void bottomSheetProvinceStore(_city) {
  Timer? _debounce;
  SettingsController controller = Get.put(SettingsController());
  controller.searchLocationProvince = controller.provinceStore;
  Get.bottomSheet(
    SafeArea(
      child: Container(
          height: Get.height * .95,
          padding:
              const EdgeInsets.only(top: 24, right: 24, bottom: 0, left: 24),
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: GetBuilder<SettingsController>(
              init: controller,
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
                          text: "Pilih Wilayah",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomSearchTextForm(
                      textHint: "Cari Provinsi atau Kota",
                      onSaved: (value) {},
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) {
                          _debounce?.cancel();
                        }
                        _debounce =
                            Timer(const Duration(milliseconds: 500), () async {
                          // do something with query
                          await controller.searchProvinceStore(value);
                        });
                      },
                      validator: (value) {
                        if (value != null || value != "") {
                          return "tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    (controller.searchLocationProvince.isEmpty)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i <
                                              controller.searchLocationProvince
                                                  .length;
                                          i++) ...[
                                        if (i == 0)
                                          InkWell(
                                            onTap: () {
                                              _city.text = controller
                                                  .searchLocationProvince[i]
                                                  .province;
                                              controller.searchLocationStore(
                                                  controller
                                                      .searchLocationProvince[i]
                                                      .province!);
                                              Get.back();
                                              controller.update();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 14),
                                              child: CustomText(
                                                text: controller
                                                    .searchLocationProvince[i]
                                                    .province,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        if (i > 0 &&
                                            controller.searchLocationProvince[i]
                                                    .province !=
                                                controller
                                                    .searchLocationProvince[
                                                        i - 1]
                                                    .province)
                                          InkWell(
                                            onTap: () {
                                              _city.text = controller
                                                  .searchLocationProvince[i]
                                                  .province;
                                              controller.searchLocationStore(
                                                  controller
                                                      .searchLocationProvince[i]
                                                      .province!);
                                              Get.back();
                                              controller.update();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 14),
                                              child: CustomText(
                                                text: controller
                                                    .searchLocationProvince[i]
                                                    .province,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        InkWell(
                                            onTap: () {
                                              _city.text = controller
                                                  .searchLocationProvince[i]
                                                  .city;
                                              controller.searchLocationStore(
                                                  controller
                                                      .searchLocationProvince[i]
                                                      .city!);
                                              Get.back();
                                              controller.update();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 40),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CustomText(
                                                    text: controller
                                                        .searchLocationProvince[
                                                            i]
                                                        .city,
                                                    fontSize: 14,
                                                    fontWeight: (_city.text ==
                                                            controller
                                                                .searchLocationProvince[
                                                                    i]
                                                                .city)
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                  (_city.text ==
                                                          controller
                                                              .searchLocationProvince[
                                                                  i]
                                                              .city)
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
                  ],
                );
              })),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
