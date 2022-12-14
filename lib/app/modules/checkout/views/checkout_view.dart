import 'package:colorbox/app/modules/checkout/views/list_address.dart';
import 'package:colorbox/app/modules/checkout/views/payment_view.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/address_widget.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/alert_stock.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/item_checkout.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/shipping_widget.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/voucher_widget.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    Future<bool> showAlert() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                height: 240,
                child: GetBuilder<CheckoutController>(builder: (_) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          CustomText(
                            text: (controller.checkout.shippingLine != null &&
                                    controller.checkout.shippingLine!.title!
                                        .contains("COD"))
                                ? 'Konfirmasi Pesanan'
                                : 'Lakukan pembayaran?',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: (controller.checkout.shippingLine != null &&
                                    controller.checkout.shippingLine!.title!
                                        .contains("COD"))
                                ? 'Buat Pesanan? Pastikan pesanan kamu sudah sesuai'
                                : 'Pastikan pesanan kamu sudah sesuai',
                            fontSize: 14,
                            textAlign: TextAlign.center,
                            textOverflow: TextOverflow.fade,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            backgroundColor: colorTextBlack,
                            color: Colors.white,
                            onPressed: (controller.checkoutTap)
                                ? null
                                : () async {
                                    String? urlString =
                                        await controller.createOrder();
                                    if (urlString == "" || urlString == null) {
                                      return;
                                    }
                                    if (urlString == "stok-habis") {
                                      alertStock(context);
                                      return;
                                    }

                                    if (urlString == "COD") {
                                      Get.until((route) =>
                                          Get.currentRoute == "/controlv2");
                                      Get.toNamed(Routes.ORDERS);
                                      return;
                                    }

                                    Navigator.of(context).pop(true);
                                    Get.off(WebPaymentView(
                                        title: "Pembayaran", url: urlString));
                                  },
                            //return true when click on "Yes"
                            text: (controller.checkout.shippingLine!.title!
                                    .contains("COD"))
                                ? 'Ya, Buat Pesanan'
                                : 'Lanjut Bayar',
                            fontSize: 14,
                            width: Get.width,
                            height: 45,
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            backgroundColor: Colors.white,
                            onPressed: (controller.checkoutTap)
                                ? null
                                : () => Navigator.of(context).pop(false),
                            //return false when click on "No"
                            text: 'Kembali',
                            fontSize: 14,
                            width: Get.width,
                            height: 45,
                          ),
                        ],
                      ),
                      (controller.checkoutTap)
                          ? loadingCircular()
                          : const SizedBox()
                    ],
                  );
                }),
              ),
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Checkout",
          )),
      backgroundColor: Colors.white,
      body: GetBuilder(
          init: Get.put(CheckoutController()),
          builder: (c) {
            return SafeArea(
                child: (controller.checkout.id == null)
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: colorTextBlack,
                        ),
                      )
                    : Column(
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 24, 16, 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              CustomText(
                                                text: "Pengiriman",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              SizedBox(height: 12),
                                              AddressWidget(),
                                              SizedBox(height: 16),
                                              ShippingWidget(),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: colorDiver,
                                          height: 8,
                                        ),
                                        Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                text: "Produk",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              const SizedBox(height: 12),
                                              ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  separatorBuilder:
                                                      (_, index) =>
                                                          const SizedBox(
                                                              height: 16),
                                                  itemCount: controller.checkout
                                                      .lineItems!.length,
                                                  itemBuilder: (_, index) {
                                                    return ItemCheckoutWidget(
                                                      formatter: formatter,
                                                      controller: controller,
                                                      index: index,
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          color: colorDiver,
                                          height: 8,
                                        ),
                                        const VoucherWidget(),

                                        Container(
                                          color: colorDiver,
                                          height: 8,
                                        ),
                                        //ringkasan total
                                        Container(
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(16),
                                          width: Get.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const CustomText(
                                                text: "Ringkasan Belanja",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                    text: "Subtotal Produk",
                                                    fontSize: 12,
                                                    color: colorTextBlack,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        "Rp ${formatter.format(double.parse(controller.checkout.lineItemsSubtotalPrice!.replaceAll(".0", "")).round())}",
                                                    color: colorTextBlack,
                                                    fontSize: 12,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                    text: "Ongkos Kirim",
                                                    fontSize: 12,
                                                    color: colorTextBlack,
                                                  ),
                                                  (controller.checkout
                                                                  .shippingLine ==
                                                              null ||
                                                          controller
                                                                  .checkout
                                                                  .shippingLine!
                                                                  .amount ==
                                                              null)
                                                      ? const CustomText(
                                                          text: "Rp 0",
                                                          fontSize: 12,
                                                          color: colorTextBlack,
                                                        )
                                                      : CustomText(
                                                          text:
                                                              "Rp ${formatter.format(double.parse(controller.checkout.shippingLine!.amount!.replaceAll(".0", "")).round())}",
                                                          color: colorTextBlack,
                                                          fontSize: 12,
                                                        ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                    text: "Potongan Harga",
                                                    fontSize: 12,
                                                    color: colorTextBlack,
                                                  ),
                                                  (controller.checkout
                                                                  .discountApplications ==
                                                              null ||
                                                          controller
                                                              .checkout
                                                              .discountApplications!
                                                              .isEmpty)
                                                      ? const CustomText(
                                                          text: "Rp 0",
                                                          fontSize: 12,
                                                          color: colorTextBlack,
                                                        )
                                                      : (controller
                                                                  .discountAmount ==
                                                              null)
                                                          ? CustomText(
                                                              text:
                                                                  "-Rp ${formatter.format(double.parse(controller.checkout.discountApplications![0].amount!.replaceAll(".0", "")).round())}",
                                                              color:
                                                                  colorTextBlack,
                                                              fontSize: 12,
                                                            )
                                                          : CustomText(
                                                              text:
                                                                  "-Rp ${formatter.format(controller.discountAmount!.round())}",
                                                              color:
                                                                  colorTextBlack,
                                                              fontSize: 12,
                                                            ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        //footer
                                        const SizedBox(height: 40)
                                      ],
                                    ),
                                    (controller.loading.value)
                                        ? SizedBox(
                                            height: Get.height,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: colorTextBlack,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(
                                      0, -5), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomText(
                                      text: "Total Harga",
                                      fontSize: 14,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CustomText(
                                      text:
                                          "Rp ${formatter.format(double.parse((controller.checkout.totalPriceV2 ?? "0").replaceAll(".0", "")).round())}",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  onPressed: (controller
                                              .checkout
                                              .availableShippingRates!
                                              .shippingRates!
                                              .isEmpty &&
                                          controller.checkout.shippingLine ==
                                              null)
                                      ? null
                                      : () async {
                                          showAlert();
                                        },
                                  text: (controller.checkout.shippingLine !=
                                              null &&
                                          controller
                                              .checkout.shippingLine!.title!
                                              .contains("COD"))
                                      ? "Buat Pesanan"
                                      : "Lakukan Pembayaran",
                                  color: Colors.white,
                                  backgroundColor: colorTextBlack,
                                  width: 200,
                                  height: 48,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
          }),
    );
  }

  void bottomSheet(show) {
    Widget modal;
    switch (show) {
      case "address":
        modal = ListAddress(controller: controller);
        break;
      default:
        modal = ListAddress(controller: controller);
        break;
    }

    Get.bottomSheet(
      modal,
      isDismissible: true,
      enableDrag: false,
    );
  }
}
