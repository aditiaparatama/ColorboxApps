import 'package:colorbox/app/modules/collections/views/widgets/search_collection.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/control/views/submenu_v2_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/appbar_custom.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
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
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: AppBarCustom(
                widget: SearchCollection(),
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                const SizedBox(height: 12),
                Flexible(
                  child: SizedBox(
                    child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (_, index) => const Divider(
                              color: colorBorderGrey,
                              thickness: 1,
                            ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: c.menu.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              (c.menu[index].subMenu.isNotEmpty)
                                  ? Get.to(SubmenuV2View(curIndex: index))
                                  : Get.toNamed(Routes.COLLECTIONS, arguments: {
                                      "menu": c.menu[index],
                                      "menuIndex": null,
                                      "sortBy": defaultSortBy
                                    });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: CachedNetworkImage(
                                          imageUrl: c.menu[index].image!,
                                          fit: BoxFit.cover,
                                          height: 50.0,
                                          width: 50.0,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      CustomText(
                                        text: c.menu[index].title!,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(0, 0, 0, 1),
                                      ),
                                    ],
                                  ),
                                  SvgPicture.asset(
                                      "assets/icon/bx-arrow-right2.svg"),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
