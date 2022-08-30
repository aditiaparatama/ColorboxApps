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
  final String? filter;
  OrdersView({Key? key, this.filter}) : super(key: key);
  final ScrollController _sControl = ScrollController();

  void onScroll() {
    double maxScroll = _sControl.position.maxScrollExtent;
    double currentScroll = _sControl.position.pixels;

    if (currentScroll == maxScroll && controller.pageInfo.hasNextPage!) {
      if (!controller.loadingMore.value) {
        controller.loadMore();
        controller.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _sControl.addListener(onScroll);
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
        leadingWidth: 36,
        // backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: GetBuilder(
          init: Get.put(OrdersController()),
          builder: (_) {
            controller.filterDataOrders(filter);

            return SafeArea(
                child: (controller.loading.value)
                    ? loadingCircular()
                    : Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Stack(
                          children: [
                            ListView.separated(
                                controller: _sControl,
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 16),
                                itemCount: controller.ordersFilter.length,
                                itemBuilder: (_, index) {
                                  dynamic variant = controller
                                      .ordersFilter[index]
                                      .lineItems!
                                      .items![0]
                                      .variantTitle!
                                      .split("/");
                                  String? status =
                                      controller.ordersFilter[index].status;
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

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: (index == 0) ? 24 : 0,
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Get.to(OrderDetailView(index)),
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color(0xFFE5E8EB)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(6)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                            .ordersFilter[index]
                                                            .status,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                    text: "No Pesanan",
                                                    fontSize: 12,
                                                    color: Color(0xFF777777),
                                                  ),
                                                  CustomText(
                                                    text: controller
                                                        .ordersFilter[index]
                                                        .name,
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
                                                    imageUrl: controller
                                                        .ordersFilter[index]
                                                        .lineItems!
                                                        .items![0]
                                                        .image!,
                                                    height: 55,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: Get.width * .65,
                                                        child: CustomText(
                                                          text: controller
                                                              .ordersFilter[
                                                                  index]
                                                              .lineItems!
                                                              .items![0]
                                                              .title,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const CustomText(
                                                            text: "Warna : ",
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF777777),
                                                          ),
                                                          CustomText(
                                                            text: variant[1]
                                                                .trim(),
                                                            fontSize: 12,
                                                            color: const Color(
                                                                0xFF777777),
                                                          ),
                                                          const SizedBox(
                                                              width: 16),
                                                          const CustomText(
                                                            text: "Ukuran : ",
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF777777),
                                                          ),
                                                          CustomText(
                                                            text: variant[0]
                                                                .trim(),
                                                            fontSize: 12,
                                                            color: const Color(
                                                                0xFF777777),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: (controller
                                                              .ordersFilter[
                                                                  index]
                                                              .lineItems!
                                                              .items!
                                                              .length >
                                                          1)
                                                      ? 8
                                                      : 0),
                                              (controller
                                                          .ordersFilter[index]
                                                          .lineItems!
                                                          .items!
                                                          .length >
                                                      1)
                                                  ? CustomText(
                                                      text:
                                                          "+ ${controller.ordersFilter[index].subtotalLineItemsQuantity! - 1} produk lainnya",
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const CustomText(
                                                      text: "Total",
                                                      fontSize: 12,
                                                      color: Color(0xFF777777)),
                                                  CustomText(
                                                    text:
                                                        "Rp ${formatter.format(int.parse(controller.ordersFilter[index].totalPriceSet!.shopMoney!.replaceAll(".0", "")))}",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            (controller.loadingMore.value)
                                ? Positioned(
                                    bottom: 10,
                                    left: Get.width * .4,
                                    child: const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ));
          }),
    );
  }
}
