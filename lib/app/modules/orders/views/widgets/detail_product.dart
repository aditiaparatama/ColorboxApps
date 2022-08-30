import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/orders/models/order_model.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProductOrder extends StatelessWidget {
  final Order order;
  const DetailProductOrder({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Detail Produk",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemCount: order.lineItems!.items!.length,
              itemBuilder: (_, index) {
                var x = order.lineItems!.items![index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E8EB)),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
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
                          SizedBox(
                            width: Get.width * .65,
                            child: CustomText(
                              text: x.title,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CustomText(
                                text: "Warna : ",
                                fontSize: 12,
                                color: Color(0xFF777777),
                              ),
                              CustomText(
                                text: x.variantTitle!.split("/")[1].trim(),
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
                                text: x.variantTitle!.split("/")[0].trim(),
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
                );
              }),
        ],
      ),
    );
  }
}
