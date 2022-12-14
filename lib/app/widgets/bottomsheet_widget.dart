import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void bottomSheetWidget(header, title, text) {
  var splitText = text.split("#");
  Get.bottomSheet(
    Container(
      height: Get.height * .35,
      padding: const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
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
                CustomText(
                  text: header,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            CustomText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 12),
            for (final x in splitText[0].split("•")) ...[
              CustomText(
                text: "• $x",
                fontSize: 14,
                color: colorTextBlack,
              ),
              const SizedBox(height: 4),
            ],
            const SizedBox(height: 8),
            if (splitText.length > 1)
              CustomText(
                text: splitText[1],
                fontSize: 14,
              )
          ]),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
