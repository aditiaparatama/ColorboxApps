import 'package:colorbox/app/modules/checkout/views/list_address.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/address_widget.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/item_checkout.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/shipping_widget.dart';
import 'package:colorbox/app/modules/checkout/views/widgets/voucher_widget.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
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
                  backgroundColor: Colors.black87,
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

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Checkout',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
          elevation: 3,
          shadowColor: Colors.grey.withOpacity(0.3),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        body: GetBuilder(
            init: Get.put(CheckoutController()),
            builder: (c) {
              return SafeArea(
                  child: (controller.checkout.id == null)
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : SingleChildScrollView(
                          child: SizedBox(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    const AddressWidget(),
                                    const SizedBox(
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
                                          customDivider(),
                                          for (int index = 0;
                                              index <
                                                  controller.checkout.lineItems!
                                                      .length;
                                              index++) ...[
                                            ItemCheckoutWidget(
                                              formatter: formatter,
                                              controller: controller,
                                              index: index,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                          ],
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          const ShippingWidget(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
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
                                          const VoucherWidget(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: customDivider(),
                                          ),
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
                                                text: "Total Harga",
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                              CustomText(
                                                text:
                                                    "Rp ${formatter.format(int.parse(controller.checkout.totalPriceV2!.replaceAll(".0", "")))}",
                                                color: Colors.black54,
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
                                                text: "Total Ongkos Kirim",
                                                fontSize: 12,
                                                color: Colors.black54,
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
                                                      color: Colors.black54,
                                                    )
                                                  : CustomText(
                                                      text:
                                                          "Rp ${formatter.format(int.parse(controller.checkout.shippingLine!.amount!.replaceAll(".0", "")))}",
                                                      color: Colors.black54,
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
                                                text: "Total Diskon Barang",
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                              (controller.checkout
                                                          .discountApplications ==
                                                      null)
                                                  ? const CustomText(
                                                      text: "Rp 0",
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    )
                                                  : CustomText(
                                                      text:
                                                          "-Rp ${formatter.format(int.parse(controller.checkout.discountApplications!.amount!.replaceAll(".0", "")))}",
                                                      color: Colors.black54,
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
                                                text: "Total",
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
                                            onPressed: () {},
                                            text: "Lakukan Pembayaran",
                                            color: Colors.white,
                                            backgroundColor: Colors.black87,
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
                                            color: Colors.black,
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
