import 'dart:async';

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
  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      controller.searchProvince(query);
      controller.update();
    });
  }

  Get.bottomSheet(
    SafeArea(
      child: Container(
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
                      onChanged: _onSearchChanged,
                      onSaved: (value) {},
                      validator: (value) {
                        if (value != null || value != "") {
                          return "tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    (controller.province == null)
                        ? SizedBox(child: loadingCircular())
                        : Expanded(
                            child: SizedBox(
                              width: Get.width,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (final x in controller.province!) ...[
                                      InkWell(
                                          onTap: () {
                                            _province.text = x.name!;
                                            _city.text = "";
                                            Get.back();
                                            controller.update();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CustomText(
                                                  text: x.name!,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      (_province.text == x.name)
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                                (_province.text == x.name)
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: colorTextBlack,
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          )),
                                      const Divider(),
                                    ],
                                  ],
                                ),
                              ),
                            ),
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
