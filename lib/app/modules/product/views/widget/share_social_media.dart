import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorbox/constance.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';

void bottomSheet(handle) {
  // ignore: unused_local_variable
  var urlprod = 'https://colorbox.co.id/products/' + handle;
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(defaultPadding),
      height: Get.height * .45,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                  )),
              const CustomText(
                text: "Berbagi :",
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () async {
              var url = 'https://www.facebook.com/sharer/sharer.php?u=' +
                  urlprod +
                  '?utm_source=Facebook';
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/icon/sm-facebook.svg",
                    width: 24, height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: 'Facebook',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: colorDiver,
            thickness: 1,
          ),
          TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () async {
              var url = 'https://twitter.com/intent/tweet?text=' +
                  urlprod +
                  '%3Futm_source%3DTwitter&amp;text=Check+out+this+product%21+Product+ini+mungkin+menarik+buat+kamu%3A%0D%0A%0D%0A';
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/icon/sm-twitter.svg",
                    width: 24, height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: 'Twitter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: colorDiver,
            thickness: 1,
          ),
          TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () async {
              var url =
                  'https://api.whatsapp.com/send?text=Check+out+this+product%21+Product+ini+mungkin+menarik+buat+kamu%3A%0D%0A%0D%0A' +
                      urlprod +
                      '%3Futm_source%3DWhatsapp';
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/icon/sm-whatsapp.svg",
                    width: 24, height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: 'Whatsapp',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: colorDiver,
            thickness: 1,
          ),
          TextButton(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
            onPressed: () async {
              var url =
                  'tg://msg_url?text=%0D%0A%0D%0ACheck out this product! produk ini mungkin menarik buat kamu:&url=' +
                      urlprod +
                      '%3Futm_source%3DTelegram';
              await launchUrlString(url, mode: LaunchMode.externalApplication);
            },
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/icon/sm-telegram.svg",
                    width: 24, height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: 'Telegram',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: colorDiver,
            thickness: 1,
          ),
        ],
      ),
    ),
    isDismissible: true,
    enableDrag: false,
  );
}
