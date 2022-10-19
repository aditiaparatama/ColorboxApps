import 'package:colorbox/app/modules/orders/models/order_model.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TimelineStatus extends StatelessWidget {
  final Order order;
  final String? filter;
  const TimelineStatus({Key? key, required this.order, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filter == null)
            Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 75,
                  child: Container(
                    color: (order.status == "Diproses")
                        ? colorTextBlack
                        : (order.status == "Dikirim")
                            ? colorTextBlack
                            : const Color(0xFFE5E8EB),
                    height: 2,
                    width: 100,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 75,
                  child: Container(
                    color: (order.status == "Dikirim")
                        ? colorTextBlack
                        : const Color(0xFFE5E8EB),
                    height: 2,
                    width: 100,
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
                        checked: (order.status == "Diproses")
                            ? true
                            : (order.status == "Dikirim")
                                ? true
                                : false),
                    timelineWidget(
                        icon: "assets/icon/orders/Dikirim.svg",
                        status: "Dikirim",
                        checked: (order.status == "Dikirim") ? true : false),
                  ],
                ),
              ],
            ),
          if (filter == null) const SizedBox(height: 28),
          const CustomText(
            text: "Detail Pengiriman",
            fontSize: 14,
            fontWeight: FontWeight.bold,
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
                  text: (order.shippingLine == null)
                      ? ""
                      : order.shippingLine!.title,
                  fontSize: 12)
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
                          "${order.shippingAddress!.firstName} ${order.shippingAddress!.lastName}",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: order.shippingAddress!.phone,
                      fontSize: 12,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text: order.shippingAddress!.address1,
                      fontSize: 12,
                      textOverflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text:
                          "${order.shippingAddress!.address2}, ${order.shippingAddress!.city}",
                      fontSize: 12,
                      textOverflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text:
                          "${order.shippingAddress!.province}, ${order.shippingAddress!.zip}",
                      fontSize: 12,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
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
                  (checked) ? colorTextBlack : const Color(0xFFE5E8EB),
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
            color: (checked) ? colorTextBlack : const Color(0xFF9B9B9B),
          )
        ],
      ),
    );
  }
}
