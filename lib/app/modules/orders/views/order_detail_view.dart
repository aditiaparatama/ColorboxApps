import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/modules/orders/models/order_model.dart';
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
        actions: [
          InkWell(
            onTap: () async {
              const url = "https://wa.me/6285275489155?text=YYYYYY";

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
                  Container(
                    padding: const EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              top: 20,
                              left: 75,
                              child: Container(
                                color: const Color(0xFFE5E8EB),
                                height: 2,
                                width: 70,
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 75,
                              child: Container(
                                color: const Color(0xFFE5E8EB),
                                height: 2,
                                width: 70,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                timelineWidget(
                                    icon: "assets/icon/orders/wallet-solid.svg",
                                    status: "Menunggu Pembayaran",
                                    checked: true),
                                timelineWidget(
                                    icon: "assets/icon/orders/box-solid.svg",
                                    status: "Diproses",
                                    checked: false),
                                timelineWidget(
                                    icon: "assets/icon/orders/Dikirim.svg",
                                    status: "Dikirim",
                                    checked: false),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const CustomText(
                          text: "Detail Pengiriman",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Kurir",
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                            const SizedBox(width: 51),
                            CustomText(
                                text: _order.shippingLine!.title, fontSize: 12)
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "Alamat",
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                            const SizedBox(width: 38),
                            SizedBox(
                              width: Get.width * .67,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text:
                                        "${_order.shippingAddress!.firstName} ${_order.shippingAddress!.lastName}",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: _order.shippingAddress!.phone,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 2),
                                  CustomText(
                                    text: _order.shippingAddress!.address1,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 2),
                                  CustomText(
                                    text:
                                        "${_order.shippingAddress!.address2}, ${_order.shippingAddress!.city}",
                                    fontSize: 12,
                                  ),
                                  const SizedBox(height: 2),
                                  CustomText(
                                    text:
                                        "${_order.shippingAddress!.province}, ${_order.shippingAddress!.zip}",
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Detail Produk",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 16),
                        for (final x in _order.lineItems!.items!) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFE5E8EB)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: x.image!,
                                  height: 65,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: x.title,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          text: "Warna : ",
                                          fontSize: 12,
                                          color: Color(0xFF777777),
                                        ),
                                        CustomText(
                                          text: x.variantTitle!
                                              .split("/")[1]
                                              .trim(),
                                          fontSize: 12,
                                          color: const Color(0xFF777777),
                                        ),
                                        const SizedBox(width: 16),
                                        const CustomText(
                                          text: "Ukuran : ",
                                          fontSize: 12,
                                          color: Color(0xFF777777),
                                        ),
                                        CustomText(
                                          text: x.variantTitle!
                                              .split("/")[0]
                                              .trim(),
                                          fontSize: 12,
                                          color: const Color(0xFF777777),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text:
                                          "Rp ${formatter.format(int.parse(x.originalUnitPriceSet!.shopMoney!.replaceAll(".0", "")))}",
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Detail Pembayaran",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 16),
                        Row(
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
                                InkWell(
                                    onTap: () {},
                                    child:
                                        const Icon(Icons.keyboard_arrow_down))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget timelineWidget(
      {String icon = "assets/icon/orders/wallet-solid.svg",
      String status = "",
      bool checked = false}) {
    return SizedBox(
      width: 109,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor:
                  (checked) ? Colors.black : const Color(0xFFE5E8EB),
              child: SvgPicture.asset(
                icon,
                color: (checked) ? Colors.white : const Color(0xFF9B9B9B),
              ),
            ),
          ),
          const SizedBox(height: 4),
          CustomText(
            text: status,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            textOverflow: TextOverflow.fade,
            textAlign: TextAlign.center,
            color: (checked) ? Colors.black : const Color(0xFF9B9B9B),
          )
        ],
      ),
    );
  }
}
