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
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 24, 21, 12),
          itemCount: c[curIndex].subMenu.length,
          itemBuilder: (BuildContext _, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 8),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.COLLECTIONS, arguments: {
                    "menu": c[curIndex].subMenu,
                    "indexMenu": index,
                    "sortBy": defaultSortBy
                  });
                },
                child: SizedBox(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1.0,
                            color: Color.fromRGBO(229, 232, 235, 1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 2, 0, 7),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CachedNetworkImage(
                                  imageUrl: c[curIndex].subMenu[index].image!,
                                  fit: BoxFit.cover,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 0, 5),
                              child: CustomText(
                                text: c[curIndex]
                                    .subMenu[index]
                                    .title!
                                    .replaceAll("- New Arrival", ""),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorTextBlack,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset("assets/icon/bx-arrow-right2.svg"),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget bagWidget() {
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
            Get.find<CartController>().cart.lines!.isNotEmpty
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
                        text: Get.find<CartController>()
                            .cart
                            .lines!
                            .length
                            .toString(),
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
  }
}
