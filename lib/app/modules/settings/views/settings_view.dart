import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_card.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

// ignore: use_key_in_widget_constructors
class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    controller.getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        centerTitle: true,
      ),
      body: GetBuilder<SettingsController>(
          init: Get.put(SettingsController()),
          builder: (c) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Profile",
                          color: Colors.grey,
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: (c.userModel.displayName == null)
                              ? const CustomText(text: "Sign In / Sign Up")
                              : CustomText(
                                  text: c.userModel.displayName,
                                ),
                          onTap: () {
                            (c.userModel.displayName == null)
                                ? Get.toNamed(Routes.PROFILE,
                                    arguments: [c, "settings"])
                                : null;
                          },
                        ),
                        (c.userModel.displayName == null)
                            ? const SizedBox()
                            : ListTile(
                                leading: const Icon(Icons.logout),
                                title: const CustomText(text: "Log Out"),
                                onTap: () {
                                  c.logout();
                                },
                              )
                      ],
                    ),
                  )),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomCard(
                    textHeader: "Info",
                    items: [
                      Items("About COLORBOX",
                          "https://colorbox.co.id/pages/about-us"),
                      Items(
                          "Contact", "https://colorbox.co.id/pages/contact-us"),
                      Items("Size Guide",
                          "https://colorbox.co.id/pages/size-chart"),
                      Items("Terms of Service",
                          "https://colorbox.co.id/policies/terms-of-service"),
                      Items("Refund Policy",
                          "https://colorbox.co.id/policies/refund-policy"),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomCard(
                    textHeader: "Help",
                    items: [
                      Items("FAQ", "https://colorbox.co.id/pages/faqs"),
                      Items("How to Order",
                          "https://colorbox.co.id/pages/pemesanan"),
                      Items(
                          "Payment", "https://colorbox.co.id/pages/pembayaran"),
                      Items("Delivery",
                          "https://colorbox.co.id/pages/pengiriman"),
                      Items("Retur Product",
                          "https://colorbox.co.id/pages/retur"),
                    ],
                  ),
                ],
              ),
            ));
          }),
    );
  }
}
