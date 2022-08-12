import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/control/views/submenu_v2_view.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class CollectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlController>(builder: (c) {
      return DefaultTabController(
          length: c.listTabs.length,
          child: Builder(builder: (context) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 36,
                      width: MediaQuery.of(context).size.width - 85,
                      child: TextFormField(
                        cursorColor: const Color.fromRGBO(155, 155, 155, 1),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 5),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Cari produk disini",
                          filled: true,
                          fillColor: const Color.fromRGBO(250, 250, 250, 1),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: GestureDetector(
                              onTap: () => Get.toNamed(Routes.SEARCH),
                              child: SvgPicture.asset(
                                  "assets/icon/bx-search1.svg"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      width: 50,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.CART, arguments: "collection");
                        },
                        child: CircleAvatar(
                          radius: 16.0,
                          child: SvgPicture.asset("assets/icon/bx-handbag.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: c.menu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: InkWell(
                        onTap: () {
                          (c.menu[index].subMenu.isNotEmpty)
                              ? Get.to(SubmenuV2View(curIndex: index))
                              : Get.toNamed(Routes.COLLECTIONS,
                                  arguments: c.menu[index]);
                        },
                        // onTap: () {
                        //   Get.to(SubmenuV2View(curIndex: index));
                        // },
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 2, 0, 7),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://cdn.shopify.com/s/files/1/0423/9120/8086/products/I-SIDKEY122G058_MED_BLUE_4_T_1280x@2x.progressive.jpg?v=1657769394",
                                        fit: BoxFit.cover,
                                        height: 50.0,
                                        width: 50.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: CustomText(
                                      text: c.menu[index].title!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
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
                    );
                  }),
            );
          }));
    });
  }
}
