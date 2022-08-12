import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingView extends GetView<CheckoutController> {
  const ShippingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
        title: const CustomText(
          text: 'Metode Pengiriman',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: SafeArea(
          child: GetBuilder(
              init: Get.put(CheckoutController()),
              builder: (c) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            for (final x in controller.checkout
                                .availableShippingRates!.shippingRates!) ...[
                              GestureDetector(
                                onTap: () =>
                                    controller.updateShipping(x.handle!),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFE5E8EB)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: x.title,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            height: defaultPadding,
                                          ),
                                          CustomText(
                                            text: controller.etd ?? "",
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      CustomText(
                                        text: x.amount ?? "FREE",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        (controller.loading.value)
                            ? loadingCircular()
                            : const SizedBox()
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}