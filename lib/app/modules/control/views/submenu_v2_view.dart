import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
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
                                    .replaceAll("- New Arrival", "")
                                    .toUpperCase(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
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
}

class SearchCollection extends StatelessWidget {
  const SearchCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 36,
          width: MediaQuery.of(context).size.width - 120,
          child: TextFormField(
            onTap: () => Get.toNamed(Routes.SEARCH),
            cursorColor: const Color.fromRGBO(155, 155, 155, 1),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
              disabledBorder: InputBorder.none,
              labelStyle: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(155, 155, 155, 1)),
              hintText: "Cari produk disini",
              filled: true,
              fillColor: const Color.fromRGBO(250, 250, 250, 1),
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.SEARCH),
                  child: SvgPicture.asset("assets/icon/bx-search1.svg"),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 36,
          width: 50,
          child: InkWell(
            onTap: () => Get.toNamed(Routes.CART, arguments: "collection"),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 16.0,
                      child: SvgPicture.asset("assets/icon/bx-handbag.svg"),
                    ),
                  ),
                ),
                Get.find<CartController>().cart.lines!.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
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
        ),
      ],
    );
  }
}
