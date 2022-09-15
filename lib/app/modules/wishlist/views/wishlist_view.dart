import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/appbar_custom.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/skeleton.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBarCustom(
          text: "Wishlist",
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder(
            init: Get.put(WishlistController()),
            builder: (c) {
              return (controller.loading.value)
                  ? loadingCircular()
                  : (controller.product.isEmpty)
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
                                    onTap: () => controller.changeFilter(0),
                                    text: "Semua",
                                    selected: (controller.selected == 0)
                                        ? true
                                        : false,
                                  ),
                                  const SizedBox(width: 12),
                                  _containerFilter(
                                    onTap: () => controller.changeFilter(1),
                                    text: "Produk Tersedia",
                                    selected: (controller.selected == 1)
                                        ? true
                                        : false,
                                  ),
                                  const SizedBox(width: 12),
                                  _containerFilter(
                                    onTap: () => controller.changeFilter(2),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 24,
                                      crossAxisSpacing: 24,
                                      childAspectRatio: 2.6 / 5,
                                    ),
                                    itemCount: controller.product.length,
                                    itemBuilder: (_, i) {
                                      String? _compareAtPrice = controller
                                          .product[i]
                                          .variantSelected!
                                          .compareAtPrice;
                                      String? _price = controller
                                          .product[i].variantSelected!.price;
                                      return GestureDetector(
                                        onTap: () => Get.toNamed(Routes.PRODUCT,
                                            arguments: {
                                              "product": controller.product[i],
                                              "idCollection": controller
                                                  .product[i].idCollection
                                            }),
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: controller
                                                        .product[i].image[0],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        AspectRatio(
                                                      aspectRatio: 2.08 / 3,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        Shimmer.fromColors(
                                                            child: Skeleton(
                                                              height:
                                                                  Get.height *
                                                                      .3,
                                                              width:
                                                                  (Get.height *
                                                                          .42) /
                                                                      2,
                                                            ),
                                                            baseColor:
                                                                baseColorSkeleton,
                                                            highlightColor:
                                                                highlightColorSkeleton),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                  (controller
                                                                  .product[i]
                                                                  .variantSelected!
                                                                  .inventoryQuantity ==
                                                              null ||
                                                          controller
                                                                  .product[i]
                                                                  .variantSelected!
                                                                  .inventoryQuantity ==
                                                              0)
                                                      ? SizedBox(
                                                          height: 220,
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 60,
                                                              height: 60,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    const Color(
                                                                            0xFF212121)
                                                                        .withOpacity(
                                                                            0.65),
                                                                child:
                                                                    const CustomText(
                                                                  text: "Habis",
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              CustomText(
                                                text:
                                                    controller.product[i].title,
                                                fontSize: 12,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              (_compareAtPrice == _price ||
                                                      _compareAtPrice == "0.00")
                                                  ? const SizedBox()
                                                  : Row(
                                                      children: [
                                                        CustomText(
                                                          text:
                                                              "Rp ${formatter.format(int.parse(_compareAtPrice!.replaceAll(".00", "")))}",
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xFF9B9B9B),
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 4,
                                                                  vertical: 1),
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xFFBB0915),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2)),
                                                          child: CustomText(
                                                            text: (((int.parse(_price!.replaceAll(".00", "")) - int.parse(_compareAtPrice.replaceAll(".00", ""))) /
                                                                            int.parse(controller.product[i].variants[0].compareAtPrice!.replaceAll(".00",
                                                                                ""))) *
                                                                        100)
                                                                    .ceil()
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "-",
                                                                        "") +
                                                                "%",
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              (_compareAtPrice == _price ||
                                                      _compareAtPrice == "0.00")
                                                  ? const SizedBox()
                                                  : const SizedBox(
                                                      height: 4,
                                                    ),
                                              CustomText(
                                                text:
                                                    "Rp ${formatter.format(int.parse(_price!.replaceAll(".00", "")))}",
                                                color: (_compareAtPrice ==
                                                            _price ||
                                                        _compareAtPrice ==
                                                            "0.00")
                                                    ? colorTextBlack
                                                    : const Color(0xFFBB0915),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
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
