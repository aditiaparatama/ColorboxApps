import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Metode Pengiriman",
            icon: Icon(Icons.close),
          )),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: GetBuilder(
              init: Get.put(CheckoutController()),
              builder: (c) {
                return Padding(
                  padding: const EdgeInsets.all(16),
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
                              onTap: () => controller.updateShipping(x.handle!),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: (x.handle ==
                                              controller.checkout.shippingLine!
                                                  .handle)
                                          ? colorTextBlack
                                          : colorBorderGrey),
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
                                          text: x.etd ?? "",
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: (x.amount == "0.0")
                                              ? "FREE"
                                              : "Rp ${formatter.format(int.parse(x.amount!.replaceAll(".0", "")))}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        if (x.handle ==
                                            controller
                                                .checkout.shippingLine!.handle)
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ]
                        ],
                      ),
                      (controller.loading.value)
                          ? loadingCircular()
                          : const SizedBox()
                    ],
                  ),
                );
              })),
    );
  }
}
