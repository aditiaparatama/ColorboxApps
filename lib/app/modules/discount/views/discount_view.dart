import 'package:dotted_line/dotted_line.dart';
import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/discount_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class DiscountView extends GetView<DiscountController> {
  var formatter = DateFormat('dd MMMM yyyy');
  var voucher = Get.find<CheckoutController>().checkout.discountApplications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(
          text: 'Voucher',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: defaultPadding * 2),
        child: GetBuilder(
            init: Get.put(DiscountController()),
            builder: (context) {
              return (controller.loading.value)
                  ? loadingCircular()
                  : (controller.discount.isEmpty)
                      ? EmptyPage(
                          image: SvgPicture.asset(
                            "assets/icon/EmptyStateVoucher.svg",
                          ),
                          textHeader: "Belum Ada Voucher",
                          textContent:
                              "Saat ini belum ada voucher yang dapat digunakan",
                        )
                      : ListView.builder(
                          itemCount: controller.discount.length,
                          itemBuilder: (_, index) {
                            int _totalPrice = int.parse(
                                Get.find<CheckoutController>()
                                    .checkout
                                    .lineItemsSubtotalPrice!
                                    .replaceAll(".0", ""));

                            int _minPrice = (controller
                                        .discount[index].minimumRequirement ==
                                    null)
                                ? 0
                                : int.parse(controller
                                    .discount[index]
                                    .minimumRequirement[
                                        'greaterThanOrEqualToSubtotal']
                                        ['amount']
                                    .replaceAll(".0", ""));
                            var expired =
                                (controller.discount[index].endsAt == null)
                                    ? null
                                    : DateTime.parse(
                                        controller.discount[index].endsAt!);

                            Color _colorFont = (_totalPrice < _minPrice)
                                ? Colors.grey
                                : Colors.black;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding * 2,
                                  vertical: defaultPadding),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: (_totalPrice < _minPrice)
                                        ? null
                                        : () async {
                                            controller.loading.value = true;
                                            controller.update();
                                            await Get.find<CheckoutController>()
                                                .applyVoucher(controller
                                                    .discount[index].title!);
                                            controller.loading.value = false;
                                            controller.update();
                                          },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding * 3,
                                          vertical: defaultPadding * 2),
                                      width: Get.width,
                                      height: 170,
                                      decoration: BoxDecoration(
                                          color: (voucher != null)
                                              ? (_totalPrice < _minPrice)
                                                  ? const Color(0xFF212121)
                                                      .withOpacity(0.05)
                                                  : (voucher!.code ==
                                                          controller
                                                              .discount[index]
                                                              .title)
                                                      ? const Color(0xFF212121)
                                                          .withOpacity(0.03)
                                                      : Colors.transparent
                                              : Colors.transparent,
                                          border: (voucher != null)
                                              ? (voucher!.code ==
                                                      controller.discount[index]
                                                          .title)
                                                  ? Border.all(
                                                      color: Colors.black)
                                                  : Border.all(
                                                      color: const Color(
                                                          0xFFE0E0E0))
                                              : Border.all(
                                                  color:
                                                      const Color(0xFFE0E0E0)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                text: controller
                                                    .discount[index].title,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: _colorFont,
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              (voucher != null)
                                                  ? (voucher!.code ==
                                                          controller
                                                              .discount[index]
                                                              .title)
                                                      ? Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          child: Row(
                                                            children: const [
                                                              Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              CustomText(
                                                                text:
                                                                    "Terpasang",
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                  : const SizedBox()
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: DottedLine(),
                                          ),
                                          for (final x in controller
                                              .discount[index].summary!
                                              .split("•")) ...[
                                            CustomText(
                                              text: "• $x",
                                              fontSize: 12,
                                              color: _colorFont,
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                          (controller.discount[index].summary!
                                                      .split("•")
                                                      .length ==
                                                  2)
                                              ? const SizedBox(
                                                  height: defaultPadding * 2,
                                                )
                                              : (controller.discount[index]
                                                          .summary!
                                                          .split("•")
                                                          .length <
                                                      4)
                                                  ? const SizedBox(
                                                      height: 4,
                                                    )
                                                  : const SizedBox(),
                                          Container(
                                            width: (expired == null)
                                                ? 200
                                                : (formatter
                                                            .format(expired)
                                                            .length >
                                                        12)
                                                    ? 215
                                                    : 200,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFF212121)
                                                    .withOpacity(0.05),
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icon/Clock.svg",
                                                  color: _colorFont,
                                                ),
                                                CustomText(
                                                  text: " Berlaku sd ",
                                                  fontSize: 12,
                                                  color: _colorFont,
                                                ),
                                                CustomText(
                                                  text: (expired == null)
                                                      ? ""
                                                      : formatter
                                                          .format(expired),
                                                  fontSize: 12,
                                                  color: _colorFont,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 145 / 2,
                                      left: -20,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: (voucher != null)
                                            ? (voucher!.code ==
                                                    controller
                                                        .discount[index].title)
                                                ? Colors.black
                                                : const Color(0xFFE0E0E0)
                                            : const Color(0xFFE0E0E0),
                                        child: const CircleAvatar(
                                          radius: 15,
                                        ),
                                      )),
                                  Positioned(
                                      top: 145 / 2,
                                      right: -20,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: (voucher != null)
                                            ? (voucher!.code ==
                                                    controller
                                                        .discount[index].title)
                                                ? Colors.black
                                                : const Color(0xFFE0E0E0)
                                            : const Color(0xFFE0E0E0),
                                        child: const CircleAvatar(
                                          radius: 15,
                                        ),
                                      )),
                                ],
                              ),
                            );
                          },
                        );
            }),
      ),
    );
  }
}
