import 'package:colorbox/app/modules/checkout/models/checkout_model.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
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
  int exist = -1;
  var voucher = (Get.find<CheckoutController>().checkout.discountApplications ==
              null ||
          Get.find<CheckoutController>().checkout.discountApplications!.isEmpty)
      ? DiscountCodeApplication.empty()
      : Get.find<CheckoutController>().checkout.discountApplications![0];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    for (final x in Get.find<CheckoutController>().checkout.lineItems ?? []) {
      if (x.discountAllocations != null &&
          x.discountAllocations.isNotEmpty &&
          x.discountAllocations![0].discountApplication.typename ==
              "AutomaticDiscountApplication") {
        exist = 1;
        break;
      }
      if (exist > 0) break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Voucher",
            icon: Icon(Icons.close),
          )),
      body: GetBuilder(
          init: Get.put(DiscountController()),
          builder: (_) {
            return (controller.loading.value)
                ? loadingCircular()
                : (controller.discount.isEmpty)
                    ? EmptyPage(
                        image: Image.asset(
                          "assets/icon/vouchers.gif",
                          height: 180,
                        ),
                        textHeader: "Belum Ada Voucher",
                        textContent:
                            "Belum ada voucher yang dapat kamu gunakan",
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 24, bottom: 16),
                              child: TextFormField(
                                controller: searchController,
                                cursorColor: colorTextBlack,
                                onChanged: (value) => controller.update(),
                                decoration: InputDecoration(
                                    hintText: "Masukkan Kode Voucher",
                                    hintStyle: const TextStyle(fontSize: 12),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: CustomButton(
                                        onPressed: (searchController.text == "")
                                            ? null
                                            : () async {
                                                if (exist > 0) {
                                                  await showAlert(context,
                                                      searchController.text);
                                                  return;
                                                }
                                                controller.loading.value = true;
                                                controller.update();
                                                await Get.find<
                                                        CheckoutController>()
                                                    .applyVoucher(
                                                        searchController.text);
                                                controller.loading.value =
                                                    false;
                                                controller.update();
                                              },
                                        text: "Gunakan",
                                        color: Colors.white,
                                        backgroundColor: colorTextBlack,
                                        height: 40,
                                        width: 94,
                                        fontSize: 12,
                                        radius: 6,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        borderSide: BorderSide(
                                            color: colorTextBlack, width: 1)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E0E0)))),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.discount.length,
                              itemBuilder: (_, index) {
                                int _totalPrice = int.parse(
                                    Get.find<CheckoutController>()
                                        .checkout
                                        .lineItemsSubtotalPrice!
                                        .replaceAll(".0", ""));

                                int _minPrice = (controller.discount[index]
                                            .minimumRequirement ==
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
                                    : colorTextBlack;

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
                                                if (exist > 0) {
                                                  await showAlert(
                                                      context,
                                                      controller.discount[index]
                                                          .title!);
                                                  return;
                                                }
                                                controller.loading.value = true;
                                                controller.update();
                                                await Get.find<
                                                        CheckoutController>()
                                                    .applyVoucher(controller
                                                        .discount[index]
                                                        .title!);
                                                controller.loading.value =
                                                    false;
                                                controller.update();
                                              },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: defaultPadding * 3,
                                              vertical: defaultPadding * 2),
                                          width: Get.width,
                                          height: 195,
                                          decoration: BoxDecoration(
                                              color: (_totalPrice < _minPrice)
                                                  ? const Color(0xFF212121)
                                                      .withOpacity(0.05)
                                                  : Colors.transparent,
                                              border: (voucher.code ==
                                                      controller.discount[index]
                                                          .title)
                                                  ? Border.all(
                                                      color: colorTextBlack)
                                                  : Border.all(
                                                      color: const Color(
                                                          0xFFE0E0E0)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                  (voucher.code ==
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
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                child: DottedLine(
                                                    dashColor: (voucher.code ==
                                                            controller
                                                                .discount[index]
                                                                .title)
                                                        ? colorTextBlack
                                                        : colorOverlay),
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
                                              (controller.discount[index]
                                                          .summary!
                                                          .split("•")
                                                          .length ==
                                                      2)
                                                  ? const SizedBox(
                                                      height:
                                                          defaultPadding * 2,
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
                                                        ? 225
                                                        : 200,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF212121)
                                                            .withOpacity(0.05),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24)),
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
                                          top: 155 / 2,
                                          left: -20,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: (voucher.code ==
                                                    controller
                                                        .discount[index].title)
                                                ? colorTextBlack
                                                : const Color(0xFFE0E0E0),
                                            child: const CircleAvatar(
                                              radius: 15,
                                            ),
                                          )),
                                      Positioned(
                                          top: 155 / 2,
                                          right: -20,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: (voucher.code ==
                                                    controller
                                                        .discount[index].title)
                                                ? colorTextBlack
                                                : const Color(0xFFE0E0E0),
                                            child: const CircleAvatar(
                                              radius: 15,
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
          }),
    );
  }

  Future<bool> showAlert(BuildContext context, String code) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const CustomText(
              text: 'Ganti Dengan Voucher?',
              fontSize: 16,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
            ),
            content: const CustomText(
              text:
                  'Saat ini kamu menggunakan promo yang sedang berjalan, menggunakan voucher berarti menghapus promo. Lanjut gunakan voucher?',
              fontSize: 14,
              textOverflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  backgroundColor: colorTextBlack,
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                    controller.loading.value = true;
                    controller.update();
                    await Get.find<CheckoutController>().applyVoucher(code);
                    controller.loading.value = false;
                    controller.update();
                  },
                  //return true when click on "Yes"
                  text: 'Gunakan Voucher',
                  fontSize: 16,
                  height: 48,
                  width: 248,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  backgroundColor: Colors.white,
                  color: colorTextBlack,
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "No"
                  text: 'Kembali',
                  fontSize: 16,
                  height: 48,
                  width: 248,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
