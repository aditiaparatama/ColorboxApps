import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/modules/orders/models/order_model.dart';
import 'package:colorbox/app/modules/orders/views/widgets/detail_product.dart';
import 'package:colorbox/app/modules/orders/views/widgets/timeline_status.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailView extends GetView<OrdersController> {
  final int id;
  // ignore: prefer_const_constructors_in_immutables
  OrderDetailView(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Detail Pesanan",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // color: Colors.white,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        leadingWidth: 36,
        actions: [
          InkWell(
            onTap: () async {
              const url = "https://wa.me/628111717250?text=YYYYYY";

              await launchUrlString(url, mode: LaunchMode.externalApplication);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.network(
                  "https://widget.delamibrands.com/colorbox/mobile/icons/ri_customer-service-line.svg"),
            ),
          )
        ],
        // backgroundColor: Colors.white,
      ),
      body: GetBuilder(
          init: Get.put(OrdersController()),
          builder: (_) {
            Order _order = controller.order[id];
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "No Pesanan",
                                fontSize: 12,
                                color: Color(0xFF777777),
                              ),
                              CustomText(
                                text: _order.name,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                text: "Tanggal Order",
                                fontSize: 12,
                                color: Color(0xFF777777),
                              ),
                              CustomText(
                                text: changeDate(_order.createdAt!),
                                fontSize: 12,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TimelineStatus(order: _order),
                    const SizedBox(height: 8),
                    DetailProductOrder(
                      order: _order,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Detail Pembayaran",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 16),
                          (!controller.show)
                              ? const SizedBox()
                              : AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 100),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CustomText(
                                            text: "Subtotal Produk",
                                            fontSize: 12,
                                            color: Color(0xFF777777),
                                          ),
                                          CustomText(
                                            text:
                                                "Rp ${formatter.format((_order.discountApplications!.isEmpty) ? int.parse(_order.subtotalPriceSet!.presentmentMoney!.replaceAll(".0", "")) : (int.parse(_order.subtotalPriceSet!.presentmentMoney!.replaceAll(".0", "")) + int.parse(_order.discountApplications![0].value!.replaceAll(".0", ""))))}",
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CustomText(
                                            text: "Subtotal Ongkos Kirim",
                                            fontSize: 12,
                                            color: Color(0xFF777777),
                                          ),
                                          CustomText(
                                            text:
                                                "Rp ${formatter.format(int.parse(_order.shippingLine!.originalPriceSet!.shopMoney!.replaceAll(".0", "")))}",
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CustomText(
                                            text: "Subtotal Voucher",
                                            fontSize: 12,
                                            color: Color(0xFF777777),
                                          ),
                                          CustomText(
                                            text: (_order.discountApplications!
                                                    .isEmpty)
                                                ? "Rp 0"
                                                : "-Rp ${formatter.format(int.parse(_order.discountApplications![0].value!.replaceAll(".0", "")))}",
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      const Divider(
                                        color: colorDiver,
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                ),
                          InkWell(
                            onTap: () {
                              controller.show = !controller.show;
                              controller.update();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  text: "Total",
                                  fontSize: 12,
                                  color: Color(0xFF777777),
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                      text:
                                          "Rp ${formatter.format(int.parse(_order.totalPriceSet!.shopMoney!.replaceAll(".0", "")))}",
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Icon((controller.show)
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down)
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
