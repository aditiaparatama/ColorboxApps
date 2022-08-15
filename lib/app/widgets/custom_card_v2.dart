import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:colorbox/app/modules/settings/views/web_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class CustomCardV2 extends GetView<SettingsController> {
  final String? textHeader;
  final List<Items>? items;

  const CustomCardV2({
    Key? key,
    this.textHeader,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: textHeader,
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          for (final item in items!) ...[
            TextButton(
              style: TextButton.styleFrom(
                fixedSize: Size(Get.width, 0),
                alignment: Alignment.centerLeft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      item.icon!,
                      const SizedBox(width: 12),
                      CustomText(text: item.title, fontSize: 14),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black,
                  ),
                ],
              ),
              onPressed: item.onTap,
            ),
            // customDivider(),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
          ],
        ],
      ),
    );
  }
}

class Items {
  final String title;
  final dynamic onTap;
  final Widget? icon;

  Items(this.title, this.onTap, this.icon);
}
