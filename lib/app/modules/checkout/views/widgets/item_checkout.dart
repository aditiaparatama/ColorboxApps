import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class ItemCheckoutWidget extends StatelessWidget {
  const ItemCheckoutWidget(
      {Key? key,
      required this.formatter,
      required this.controller,
      required this.index})
      : super(key: key);

  final NumberFormat formatter;
  final CheckoutController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final _checkout = controller.checkout.lineItems![index];
    String? _discountType = controller.checkout.discountApplications!.typename;
    final options = _checkout.variants!.title!.split("/");

    // final discountType = controller.checkout.discountApplications;

    // double? discountAmount;
    double lineItemPrice = double.parse(controller
        .checkout.lineItems![index].variants!.price!
        .replaceAll(".00", ""));

    // if (discountType != null &&
    //     _checkout.discountAllocations![0]
    //             .discountApplication!.percentage !=
    //         null) {
    //   discountAmount = double.parse(controller
    //       .checkout.lineItems![index].discountAllocations![0].allocatedAmount!
    //       .replaceAll(".0", ""));
    //   lineItemPrice = lineItemPrice - discountAmount.ceil();
    // }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorBorderGrey),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: _checkout.variants!.image!,
            height: 65,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * .65,
                child: CustomText(
                  text: controller
                      .checkout.lineItems![index].variants!.titleProduct!,
                  fontSize: 12,
                  textOverflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                        text: "Warna : ",
                        style: const TextStyle(
                          fontSize: 12,
                          color: colorTextGrey,
                        ),
                        children: [
                          TextSpan(
                              text: options[1],
                              style: const TextStyle(
                                  color: colorTextGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Ukuran : ",
                        style: const TextStyle(
                          fontSize: 12,
                          color: colorTextGrey,
                        ),
                        children: [
                          TextSpan(
                              text: options[0],
                              style: const TextStyle(
                                  color: colorTextGrey,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              (_checkout.discountAllocations != null &&
                      _checkout.discountAllocations!.isNotEmpty &&
                      _discountType == "AutomaticDiscountApplication")
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              color: colorBoxInfo,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.discount_outlined,
                                size: 12,
                                color: colorTextBlack,
                              ),
                              CustomText(
                                text:
                                    " ${controller.checkout.discountApplications!.title} [",
                                color: colorTextBlack,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                text:
                                    "-Rp ${formatter.format(double.parse(_checkout.discountAllocations![0].allocatedAmount!).ceil())}]",
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: Get.width * .7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    text:
                                        "Rp ${formatter.format(int.parse(_checkout.variants!.price!.replaceAll(".00", "")))}",
                                    decoration: TextDecoration.lineThrough,
                                    color: colorTextGrey,
                                    fontSize: 10,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text:
                                        "Rp ${formatter.format(double.parse(_checkout.variants!.price!.replaceAll(".00", "")).ceil() - double.parse(_checkout.discountAllocations![0].allocatedAmount!).ceil())}",
                                    fontSize: 12,
                                    color: colorSaleRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              CustomText(
                                text: "x${_checkout.quantity}",
                                fontSize: 12,
                                color: colorTextGrey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: Get.width * .7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Rp ${formatter.format(lineItemPrice)}",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          CustomText(
                            text: "x${_checkout.quantity}",
                            fontSize: 12,
                            color: colorTextGrey,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
