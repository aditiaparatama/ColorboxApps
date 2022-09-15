import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

void priceFilterBottomSheet() {
  CollectionsController controller = Get.put(CollectionsController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController hargaMin = TextEditingController();
  TextEditingController hargaMax = TextEditingController();
  bool alertShow = false;

  List<String> priceList = [
    "Rp 0 - Rp 100.000",
    "Rp 100.000 - Rp 200.000",
    "Rp 200.000 - Rp 300.000",
    "Rp 300.000 - Rp 400.000"
  ];

  Get.bottomSheet(
    Container(
      height: Get.height * .65,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: GetBuilder<CollectionsController>(builder: (_) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 27, right: 24, bottom: 24, left: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () => Get.back(),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                              )),
                          const SizedBox(width: 8),
                          const CustomText(
                            text: "Harga",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => controller.filterChange("Harga", ""),
                        child: const CustomText(
                          text: "Hapus",
                          color: Color(0xFF115AC8),
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, index) => const Divider(
                      color: colorDiver,
                      thickness: 1,
                    ),
                    itemCount: priceList.length,
                    itemBuilder: (_, i) {
                      return InkWell(
                        onTap: () {
                          controller.filterChange("harga", priceList[i]);
                          Get.back();
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: priceList[i],
                                fontSize: 14,
                                fontWeight:
                                    (controller.filterPrice.toLowerCase() ==
                                            priceList[i].toLowerCase())
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              (controller.filterPrice.toLowerCase() ==
                                      priceList[i].toLowerCase())
                                  ? SvgPicture.asset("assets/icon/bx-check.svg")
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 8,
              width: Get.width,
              color: const Color(0xFFF9F8F8),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 24, right: 24, bottom: 16, left: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * .4,
                          child: CustomTextFormField(
                            textEditingController: hargaMin,
                            textInputType: TextInputType.number,
                            onSave: (value) {},
                            onChange: (value) {
                              if (value.length >= 3) {
                                hargaMin.text = formatter.format(
                                    int.parse(value.replaceAll(".", "")));
                                hargaMin.selection = TextSelection.collapsed(
                                    offset: hargaMin.text.length);
                              }
                              controller.update();
                            },
                            validator: (value) {
                              return null;
                            },
                            hint: "Harga Min",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: CustomText(
                            text: "-",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * .4,
                          child: CustomTextFormField(
                            textEditingController: hargaMax,
                            textInputType: TextInputType.number,
                            onSave: (value) {},
                            onChange: (value) {
                              if (value.length >= 3) {
                                hargaMax.text = formatter.format(
                                    int.parse(value.replaceAll(".", "")));
                                hargaMax.selection = TextSelection.collapsed(
                                    offset: hargaMax.text.length);
                                if (int.parse(
                                        hargaMax.text.replaceAll(".", "")) <=
                                    int.parse(
                                        hargaMin.text.replaceAll(".", ""))) {
                                  alertShow = true;
                                } else {
                                  alertShow = false;
                                }
                              }
                              controller.update();
                            },
                            validator: (value) {
                              if (value == "") {
                                return "Tidak boleh kosong";
                              }
                              return null;
                            },
                            hint: "Harga Max",
                          ),
                        )
                      ],
                    ),
                    (alertShow)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/icon/circle-exclamation-solid.svg",
                                      height: 16),
                                  const SizedBox(width: 4),
                                  const CustomText(
                                    text:
                                        "Harga max harus lebih besar dari harga min",
                                    fontSize: 12,
                                    color: Color(0xFFDA2929),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(height: 24),
                    CustomButton(
                      onPressed: (hargaMin.text == "")
                          ? null
                          : (hargaMax.text == "")
                              ? null
                              : () {
                                  _formKey.currentState!.save();

                                  if (int.parse(
                                          hargaMax.text.replaceAll(".", "")) <=
                                      int.parse(
                                          hargaMin.text.replaceAll(".", ""))) {
                                    return;
                                  }

                                  if (_formKey.currentState!.validate()) {
                                    controller.filterChange("harga",
                                        "Rp ${hargaMin.text} - Rp ${hargaMax.text}");
                                    Get.back();
                                    Get.back();
                                  }
                                },
                      text: "Terapkan",
                      color: Colors.white,
                      backgroundColor: (hargaMin.text == "")
                          ? const Color(0xFF9B9B9B)
                          : (hargaMax.text == "")
                              ? const Color(0xFF9B9B9B)
                              : colorTextBlack,
                      borderColor: Colors.transparent,
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
  );
}
