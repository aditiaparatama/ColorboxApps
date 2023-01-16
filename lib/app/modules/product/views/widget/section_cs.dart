import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/app/modules/product/views/widget/share_social_media.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SectionCS extends GetView<ProductController> {
  const SectionCS({Key? key}) : super(key: key);

  Future<void> openWA() async {
    String message =
        "Halo Admin Colorbox, saya ingin bertanya tentang produk ini: https://colorbox.co.id/products/${controller.product.handle!}";

    String url = "https://wa.me/628111717250?text=${Uri.encodeFull(message)}";
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              await openWA();
            },
            child: Container(
              height: 64,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: colorBorderGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icon/bx-hubungi-kami.svg"),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: 'Hubungi Kami',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () {
              bottomSheet(controller.product.handle!);
            },
            child: Container(
              height: 64,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: colorBorderGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icon/bx-berbagi.svg"),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: 'Berbagi',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
