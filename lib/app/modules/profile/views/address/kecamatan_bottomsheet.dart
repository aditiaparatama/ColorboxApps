import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/widgets/custom_search_formtext.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void bottomSheetKecamatan(_address2, _zip) {
  ProfileController controller = Get.put(ProfileController());
  Get.bottomSheet(
    Container(
      height: Get.height * .75,
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
                  (controller.kecamatan['kecamatan'].length == 0)
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
                              itemCount:
                                  controller.kecamatan['kecamatan'].length,
                              itemBuilder: (_, i) {
                                var x = controller.kecamatan['kecamatan'][i];
                                return TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: Size(Get.width, 20),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    onPressed: () {
                                      _address2.text = x['nama']!;
                                      _zip.text = "";
                                      Get.back();
                                      controller.update();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: x['nama'],
                                        ),
                                        (_address2.text == x['nama'])
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
