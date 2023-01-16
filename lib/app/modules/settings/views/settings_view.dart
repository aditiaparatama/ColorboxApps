import 'package:colorbox/app/modules/orders/views/orders_view.dart';
import 'package:colorbox/app/modules/profile/views/address/address_view.dart';
import 'package:colorbox/app/modules/profile/views/infoaccount_view.dart';
import 'package:colorbox/app/modules/settings/views/hapus_akun_view.dart';
import 'package:colorbox/app/modules/settings/views/web_view.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_card_v2.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

// ignore: use_key_in_widget_constructors
class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    controller.getUser();
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "AKUN SAYA",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // color: Colors.white,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        // backgroundColor: Colors.white,
      ),
      body: GetBuilder<SettingsController>(
          init: Get.put(SettingsController()),
          builder: (c) {
            int jmlPesanan = controller.ordersController.countPesanan;
            return SingleChildScrollView(
                child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (c.userModel.displayName == null)
                        ? containerLogin(c)
                        : Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 24),
                                  child: Card(
                                    elevation: 3,
                                    shadowColor: const Color(0xFFE5E8EB)
                                        .withOpacity(0.34),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFE5E8EB),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/circle-person-black.svg"),
                                          const SizedBox(width: 16),
                                          SizedBox(
                                            width: Get.width - 150,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: c.userModel.displayName,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(height: 4),
                                                CustomText(
                                                  text: c.userModel.email,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                CustomCardV2(
                                  height: 24,
                                  textHeader: "Pengaturan Akun",
                                  items: [
                                    Items(
                                        "Informasi Akun",
                                        () => Get.to(InformationAccount()),
                                        SvgPicture.asset(
                                            "assets/icon/user-circle.svg")),
                                    Items(
                                        "Daftar Alamat",
                                        () => Get.to(const AddressView(
                                            fromDetail: true)),
                                        SvgPicture.asset(
                                            "assets/icon/map-marker-alt.svg")),
                                  ],
                                ),
                                CustomCardV2(
                                  textHeader: "Aktivitas",
                                  items: [
                                    Items(
                                        "Pesanan Saya",
                                        () => Get.toNamed(Routes.ORDERS),
                                        SvgPicture.asset("assets/icon/box.svg"),
                                        notif: (controller.pesananCount == 0)
                                            ? null
                                            : jmlPesanan),
                                    Items(
                                        "Riwayat Pesanan",
                                        () => Get.to(
                                            OrdersView(filter: "riwayat")),
                                        SvgPicture.asset(
                                            "assets/icon/clipboard-list.svg")),
                                  ],
                                )
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomCardV2(
                      height: 24,
                      textHeader: "Informasi",
                      items: [
                        Items(
                            "Tentang Colorbox",
                            () => Get.to(WebViewPage(
                                title: "Tentang Colorbox",
                                url: "https://colorbox.co.id/pages/about-us")),
                            SvgPicture.asset("assets/icon/info-circle.svg")),
                        Items(
                            "Kontak",
                            () => Get.to(WebViewPage(
                                title: "Kontak",
                                url:
                                    "https://colorbox.co.id/pages/contact-us")),
                            SvgPicture.asset("assets/icon/phone-alt.svg")),
                        Items(
                            "Panduan Ukuran",
                            () => Get.to(WebViewPage(
                                title: "Panduan Ukuran",
                                url:
                                    "https://colorbox.co.id/pages/size-chart")),
                            SvgPicture.asset("assets/icon/ruler-combined.svg")),
                        Items(
                            "Ketentuan Layanan",
                            () => Get.to(WebViewPage(
                                title: "Ketentuan Layanan",
                                url:
                                    "https://colorbox.co.id/policies/terms-of-service")),
                            SvgPicture.asset(
                                "assets/icon/question-circle.svg")),
                        Items(
                            "Kebijakan Pengembalian Uang",
                            () => Get.to(WebViewPage(
                                title: "Kebijakan Pengembalian Uang",
                                url:
                                    "https://colorbox.co.id/policies/refund-policy")),
                            SvgPicture.asset("assets/icon/sync-alt.svg")),
                      ],
                    ),
                    CustomCardV2(
                      textHeader: "Bantuan",
                      items: [
                        Items(
                            "FAQ",
                            () => Get.to(WebViewPage(
                                title: "FAQ",
                                url: "https://colorbox.co.id/pages/faqs")),
                            SvgPicture.asset("assets/icon/comment-alt.svg")),
                        (c.userModel.displayName == null)
                            ? null
                            : Items(
                                "Ajukan Hapus Akun",
                                () => Get.to(HapusAkunView()),
                                SvgPicture.asset("assets/icon/Trash-Alt.svg")),
                        (c.userModel.displayName == null)
                            ? null
                            : Items("Keluar Akun", () => c.logout(),
                                SvgPicture.asset("assets/icon/sign-out.svg")),
                      ],
                    ),
                  ],
                ),
                (controller.loading.value)
                    ? SizedBox(height: Get.height, child: loadingCircular())
                    : const SizedBox()
              ],
            ));
          }),
    );
  }

  Container containerLogin(SettingsController c) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icon/circle-person-filled.svg"),
            const SizedBox(height: 12),
            const CustomText(
              text:
                  "Anda belum masuk akun. Silahkan masuk untuk dapat berbelanja",
              fontSize: 12,
              color: Color(0xFF777777),
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              lineHeight: 1.5,
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () {
                (c.userModel.displayName == null)
                    ? Get.toNamed(Routes.PROFILE, arguments: [c, "settings"])
                    : null;
              },
              text: "Masuk Akun",
              color: Colors.white,
              backgroundColor: colorTextBlack,
            ),
            (c.userModel.displayName == null)
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.logout),
                    title: const CustomText(text: "Log Out"),
                    onTap: () async {
                      await c.logout();
                    },
                  )
          ],
        ));
  }
}
