import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:colorbox/app/modules/settings/views/web_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class CustomCardV2 extends GetView<SettingsController> {
  final String? textHeader;
  final List<Items?>? items;
  final double height;

  const CustomCardV2({Key? key, this.textHeader, this.items, this.height = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
          ),
          CustomText(
            text: textHeader,
            color: colorTextBlack,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          for (final item in items!) ...[
            if (item != null)
              InkWell(
                // style: TextButton.styleFrom(
                //   // fixedSize: Size(Get.width, 0),
                //   alignment: Alignment.centerLeft,
                // ),
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
                    Row(
                      children: [
                        (item.notif == null)
                            ? const SizedBox()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFDA2929),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: CustomText(
                                      text: "${item.notif.toString()} Pesanan",
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: colorTextBlack,
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: item.onTap,
              ),
            if (item != null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: colorDiver,
                  thickness: 1,
                ),
              ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class Items {
  final String title;
  final dynamic onTap;
  final Widget? icon;
  final int? notif;

  Items(this.title, this.onTap, this.icon, {this.notif});
}
