import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressWidget extends GetView<CheckoutController> {
  const AddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(CheckoutController()),
        builder: (c) {
          return Container(
            color: Colors.white,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 24, right: 16, bottom: 16, left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Alamat Pengiriman",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        InkWell(
                          onTap: () => Get.to(const AddressView()),
                          child: CustomText(
                            text: "Ubah Alamat",
                            color: Colors.blue.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  customDivider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              children: [
                            TextSpan(
                                text:
                                    "${controller.checkout.shippingAddress!.firstName} "),
                            TextSpan(
                                text: controller
                                    .checkout.shippingAddress!.lastName),
                            const TextSpan(text: " | "),
                            TextSpan(
                                text:
                                    controller.checkout.shippingAddress!.phone),
                          ])),
                      CustomText(
                        text: controller.checkout.shippingAddress!.address1,
                        fontSize: 12,
                      ),
                      CustomText(
                        text: controller.checkout.shippingAddress!.address2,
                        fontSize: 12,
                      ),
                      CustomText(
                        text: controller.checkout.shippingAddress!.city,
                        fontSize: 12,
                      ),
                      CustomText(
                        text:
                            "${controller.checkout.shippingAddress!.province}, ${controller.checkout.shippingAddress!.zip}",
                        fontSize: 12,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
