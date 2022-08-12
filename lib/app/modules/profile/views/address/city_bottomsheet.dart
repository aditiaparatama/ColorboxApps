import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/widgets/custom_search_formtext.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void bottomSheetCity(_city, _address2) {
  ProfileController controller = Get.put(ProfileController());
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
                        text: "Pilih Kota",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomSearchTextForm(
                    textHint: "Cari Kota",
                    onSaved: (value) {},
                    onChanged: (value) {
                      controller.searchWilayah(value, "kota");
                    },
                    validator: (value) {
                      if (value != null || value != "") {
                        return "tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  (controller.wilayah.length == 0)
                      ? const SizedBox(
                          child: Center(
                            child: CustomText(text: "Data not found"),
                          ),
                        )
                      : SizedBox(
                          height: Get.height * .5,
                          width: Get.width,
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: controller.wilayah.length,
                              itemBuilder: (_, i) {
                                var x = controller.wilayah[i];
                                return TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: Size(Get.width, 20),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    onPressed: () {
                                      _city.text = x['kota']!;
                                      _address2.text = "";
                                      Get.back();
                                      controller.update();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: x['kota'],
                                        ),
                                        (_city.text == x['kota'])
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.black,
                                              )
                                            : const SizedBox()
                                      ],
                                    ));
                              }),
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