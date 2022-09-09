import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/control/views/submenu_v2_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class CollectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlController>(
        init: Get.put(ControlController()),
        builder: (c) {
          return DefaultTabController(
              length: c.listTabs.length,
              child: Builder(builder: (context) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: AppBar(
                      title: const SearchCollection(),
                    ),
                  ),
                  body: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 24, 25, 12),
                      itemCount: c.menu.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 8),
                          child: InkWell(
                            onTap: () {
                              (c.menu[index].subMenu.isNotEmpty)
                                  ? Get.to(SubmenuV2View(curIndex: index))
                                  : Get.toNamed(Routes.COLLECTIONS, arguments: {
                                      "menu": c.menu[index],
                                      "menuIndex": null,
                                      "sortBy": defaultSortBy
                                    });
                            },
                            child: SizedBox(
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color:
                                            Color.fromRGBO(229, 232, 235, 1)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 2, 0, 7),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                              imageUrl: c.menu[index].image!,
                                              fit: BoxFit.cover,
                                              height: 50.0,
                                              width: 50.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 0, 0, 5),
                                          child: CustomText(
                                            text: c.menu[index].title!,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(
                                        "assets/icon/bx-arrow-right2.svg"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }));
        });
  }
}

class SearchCollection extends StatelessWidget {
  const SearchCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 36,
          width: MediaQuery.of(context).size.width - 85,
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
              hintText: "Cari produk disini ",
              filled: true,
              fillColor: const Color.fromRGBO(250, 250, 250, 1),
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
