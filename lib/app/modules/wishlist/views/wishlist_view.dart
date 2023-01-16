import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_custom.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  WishlistView({Key? key}) : super(key: key);

  final WishlistController controller = Get.put(WishlistController());

  Future<void> initializeSettings() async {
    await controller.fetchingNewData();
    //Simulate other services for 3 seconds
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white, body: loadingCircular());
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: AppBarCustom(
                text: "WISHLIST",
              ),
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: GetBuilder(
                  init: Get.put(WishlistController()),
                  builder: (c) {
                    return (controller.loading.value)
                        ? loadingCircular()
                        : (controller.tempProduct.isEmpty)
                            ? EmptyPage(
                                image: Image.asset(
                                  "assets/icon/WHISTLIST.gif",
                                  height: 180,
                                ),
                                textHeader: "Belum Ada Wishlist",
                                textContent:
                                    "Kamu belum menambahkan produk ke dalam wishlist",
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        _containerFilter(
                                          onTap: () =>
                                              controller.changeFilter(0),
                                          text: "Semua",
                                          selected: (controller.selected == 0)
                                              ? true
                                              : false,
                                        ),
                                        const SizedBox(width: 12),
                                        _containerFilter(
                                          onTap: () =>
                                              controller.changeFilter(1),
                                          text: "Produk Tersedia",
                                          selected: (controller.selected == 1)
                                              ? true
                                              : false,
                                        ),
                                        const SizedBox(width: 12),
                                        _containerFilter(
                                          onTap: () =>
                                              controller.changeFilter(2),
                                          text: "Produk Habis",
                                          selected: (controller.selected == 2)
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 0,
                                            crossAxisSpacing: 16,
                                            childAspectRatio: 4.1 / 9,
                                          ),
                                          itemCount: controller.product.length,
                                          itemBuilder: (_, i) {
                                            String? _compareAtPrice =
                                                (controller.product[i]
                                                            .variantSelected ==
                                                        null)
                                                    ? controller
                                                        .product[i]
                                                        .variants[0]
                                                        .compareAtPrice
                                                    : controller
                                                        .product[i]
                                                        .variantSelected!
                                                        .compareAtPrice;
                                            String? _price = (controller
                                                        .product[i]
                                                        .variantSelected ==
                                                    null)
                                                ? controller.product[i]
                                                    .variants[0].price
                                                : controller.product[i]
                                                    .variantSelected!.price;
                                            return GestureDetector(
                                              onTap: () => Get.toNamed(
                                                  Routes.PRODUCT,
                                                  arguments: {
                                                    "product":
                                                        controller.product[i],
                                                    "idCollection": controller
                                                        .product[i]
                                                        .idCollection,
                                                    "handle": controller
                                                        .product[i].handle
                                                  }),
                                              child: ItemCard(
                                                onPress: () {},
                                                controller: controller,
                                                index: i,
                                                product: controller.product[i],
                                                compareAtPrice: _compareAtPrice!
                                                    .replaceAll(".00", ""),
                                                price: _price!
                                                    .replaceAll(".00", ""),
                                                image: controller
                                                    .product[i].image[0],
                                                title:
                                                    controller.product[i].title,
                                                totalInventory: controller
                                                    .product[i].totalInventory,
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              );
                  }),
            ),
          );
        });
  }

  InkWell _containerFilter({String? text, final onTap, bool? selected}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (selected!) ? colorTextBlack : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: (selected)
              ? Border.all(color: colorTextBlack)
              : Border.all(color: const Color(0xFFE5E8EB)),
        ),
        child: CustomText(
          text: text,
          color: (selected) ? Colors.white : colorTextBlack,
          fontSize: 12,
        ),
      ),
    );
  }
}
