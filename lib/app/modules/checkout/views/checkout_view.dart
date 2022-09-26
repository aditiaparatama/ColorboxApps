import 'package:colorbox/app/modules/checkout/views/list_address.dart';
import 'package:colorbox/app/modules/checkout/views/payment_view.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/address_widget.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/item_checkout.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/shipping_widget.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/voucher_widget.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

// ignore: use_key_in_widget_constructors
class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: const CustomText(
                text: 'Close',
                fontSize: 14,
              ),
              content: const CustomText(
                text: 'Would you like to cancel your order?',
                fontSize: 12,
              ),
              actions: [
                CustomButton(
                  backgroundColor: Colors.white,
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  text: 'Yes',
                  fontSize: 12,
                  width: Get.width / 5,
                  height: 45,
                ),
                CustomButton(
                  backgroundColor: colorTextBlack,
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "No"
                  text: 'No',
                  fontSize: 12,
                  width: Get.width / 5,
                  height: 45,
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

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
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'Lakukan pembayaran?',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const CustomText(
                      text: 'Pastikan pesanan kamu sudah sesuai',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      textOverflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      backgroundColor: colorTextBlack,
                      color: Colors.white,
                      onPressed: () async {
                        String urlString = await controller.createOrder();
                        Navigator.of(context).pop(true);
                        Get.off(WebPaymentView(
                            title: "Pembayaran", url: urlString));
                      },
                      //return true when click on "Yes"
                      text: 'Lanjut Bayar',
                      fontSize: 14,
                      width: Get.width,
                      height: 45,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      backgroundColor: Colors.white,
                      onPressed: () => Navigator.of(context).pop(false),
                      //return false when click on "No"
                      text: 'Kembali',
                      fontSize: 14,
                      width: Get.width,
                      height: 45,
                    ),
                  ],
                ),
              ),
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
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
                      : SingleChildScrollView(
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
                                              separatorBuilder: (_, index) =>
                                                  const SizedBox(height: 16),
                                              itemCount: controller
                                                  .checkout.lineItems!.length,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const CustomText(
                                                text: "Subtotal Produk",
                                                fontSize: 12,
                                                color: colorTextBlack,
                                              ),
                                              CustomText(
                                                text:
                                                    "Rp ${formatter.format(int.parse(controller.checkout.lineItemsSubtotalPrice!.replaceAll(".0", "")))}",
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
                                                MainAxisAlignment.spaceBetween,
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
                                                          "Rp ${formatter.format(int.parse(controller.checkout.shippingLine!.amount!.replaceAll(".0", "")))}",
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const CustomText(
                                                text: "Potongan Harga",
                                                fontSize: 12,
                                                color: colorTextBlack,
                                              ),
                                              (controller.checkout
                                                          .discountApplications ==
                                                      null)
                                                  ? const CustomText(
                                                      text: "Rp 0",
                                                      fontSize: 12,
                                                      color: colorTextBlack,
                                                    )
                                                  : CustomText(
                                                      text:
                                                          "-Rp ${formatter.format(int.parse(controller.checkout.discountApplications!.amount!.replaceAll(".0", "")))}",
                                                      color: colorTextBlack,
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
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(16),
                                      width: Get.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    "Rp ${formatter.format(int.parse(controller.checkout.totalPriceV2!.replaceAll(".0", "")))}",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                          CustomButton(
                                            onPressed: () async {
                                              showAlert();
                                            },
                                            text: "Lakukan Pembayaran",
                                            color: Colors.white,
                                            backgroundColor: colorTextBlack,
                                            width: 200,
                                            height: 48,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    )
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
                        ));
            }),
      ),
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
