import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/widgets/custom_search_formtext.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void bottomSheetZip(_zip) {
  ProfileController controller = Get.put(ProfileController());
  Get.bottomSheet(
    Container(
      height: Get.height * .55,
      padding: const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
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
                        text: "Pilih Kode Pos",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomSearchTextForm(
                    textHint: "Kode Pos",
                    textInputType: TextInputType.number,
                    onSaved: (value) {},
                    onChanged: (value) {
                      controller.searchWilayah(value, "kode_pos");
                    },
                    validator: (value) {
                      if (value != null || value != "") {
                        return "tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  (controller.kodePos.length == 0)
                      ? SizedBox(
                          child: loadingCircular(),
                        )
                      : SizedBox(
                          height: Get.height * .35,
                          width: Get.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (final x in controller.kodePos) ...[
                                  InkWell(
                                      onTap: () {
                                        _zip.text = x!;
                                        Get.back();
                                        controller.update();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: x,
                                              fontWeight: (_zip.text == x)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                            (_zip.text == x)
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
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
                ]);
          }),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
