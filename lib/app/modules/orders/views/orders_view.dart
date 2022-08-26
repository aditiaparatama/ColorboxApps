import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/orders/views/order_detail_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const CustomText(
          text: "Pesanan Saya",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // color: Colors.white,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        // backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GetBuilder(
          init: Get.put(OrdersController()),
          builder: (_) {
            return SafeArea(
                child: (controller.loading.value)
                    ? loadingCircular()
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 24, left: 16, right: 16),
                        child: ListView.builder(
                            itemCount: controller.order.length,
                            itemBuilder: (_, index) {
                              dynamic variant = controller.order[index]
                                  .lineItems!.items![0].variantTitle!
                                  .split("/");
                              String? status = controller.order[index].status;
                              String imageStatus = "wallet-solid.svg";

                              if (status == "Menunggu Pembayaran") {
                                imageStatus = "wallet-solid.svg";
                              }
                              if (status == "Diproses") {
                                imageStatus = "box-solid.svg";
                              }
                              if (status == "Dikirim") {
                                imageStatus = "Dikirim.svg";
                              }

                              return GestureDetector(
                                onTap: () => Get.to(OrderDetailView(index)),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xFFE5E8EB)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CustomText(
                                            text: "Status Pesanan",
                                            fontSize: 12,
                                            color: Color(0xFF777777),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "assets/icon/orders/$imageStatus"),
                                              const SizedBox(width: 4),
                                              CustomText(
                                                text: controller
                                                    .order[index].status,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CustomText(
                                            text: "No Pesanan",
                                            fontSize: 12,
                                            color: Color(0xFF777777),
                                          ),
                                          CustomText(
                                            text: controller.order[index].name,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(
                                        color: colorDiver,
                                        thickness: 1,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: controller.order[index]
                                                .lineItems!.items![0].image!,
                                            height: 55,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: controller.order[index]
                                                    .lineItems!.items![0].title,
                                              ),
                                              const SizedBox(height: 8),
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
                                                    text: variant[1].trim(),
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xFF777777),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  const CustomText(
                                                    text: "Ukuran : ",
                                                    fontSize: 12,
                                                    color: Color(0xFF777777),
                                                  ),
                                                  CustomText(
                                                    text: variant[0].trim(),
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xFF777777),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: (controller
                                                      .order[index]
                                                      .lineItems!
                                                      .items!
                                                      .length >
                                                  1)
                                              ? 8
                                              : 0),
                                      (controller.order[index].lineItems!.items!
                                                  .length >
                                              1)
                                          ? CustomText(
                                              text:
                                                  "+ ${controller.order[index].lineItems!.items!.length - 1} produk lainnya",
                                              fontSize: 12,
                                            )
                                          : const SizedBox(),
                                      const SizedBox(height: 12),
                                      const Divider(
                                        color: colorDiver,
                                        thickness: 1,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const CustomText(
                                              text: "Total",
                                              fontSize: 12,
                                              color: Color(0xFF777777)),
                                          CustomText(
                                            text:
                                                "Rp ${formatter.format(int.parse(controller.order[index].totalPriceSet!.shopMoney!.replaceAll(".0", "")))}",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ));
          }),
    );
  }
}
