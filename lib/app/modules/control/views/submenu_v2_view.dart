import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/search_collection.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmenuV2View extends StatelessWidget {
  final int curIndex;
  const SubmenuV2View({Key? key, required this.curIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var c = Get.find<ControlController>().menu;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          title: const SearchCollection(),
          centerTitle: false,
          elevation: 3,
          shadowColor: Colors.grey.withOpacity(0.3),
          leadingWidth: 36,
          leading: IconButton(
              padding: const EdgeInsets.all(16),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back)),
          actions: [
            bagWidget(),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Flexible(
            child: SizedBox(
              child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                        color: colorBorderGrey,
                        thickness: 1,
                      ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: c[curIndex].subMenu.length,
                  itemBuilder: (BuildContext _, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.COLLECTIONS, arguments: {
                              "menu": c[curIndex].subMenu,
                              "indexMenu": index,
                              "sortBy": defaultSortBy
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 12, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            c[curIndex].subMenu[index].image!,
                                        fit: BoxFit.cover,
                                        height: 50.0,
                                        width: 50.0,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    CustomText(
                                      text: c[curIndex]
                                          .subMenu[index]
                                          .title!
                                          .replaceAll("- New Arrival", ""),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colorTextBlack,
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                    "assets/icon/bx-arrow-right2.svg"),
                              ],
                            ),
                          ),
                        ),
                        if (index == (c[curIndex].subMenu.length - 1))
                          const SizedBox(height: 40),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget bagWidget() {
    return GetBuilder<CartController>(
        init: Get.put(CartController()),
        builder: (cartController) {
          return Center(
            child: InkWell(
              onTap: () => Get.toNamed(Routes.CART),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    child: SvgPicture.asset(
                      "assets/icon/Handbag.svg",
                    ),
                  ),
                  cartController.cart.lines!.isNotEmpty
                      ? Positioned(
                          top: 0,
                          right: 10,
                          child: Container(
                            width: 15,
                            height: 15,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red),
                            child: CustomText(
                              text:
                                  cartController.cart.totalQuantity.toString(),
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          );
        });
  }
}
