import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_appbar.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

class SubmenuView extends GetView {
  final String currentItem;

  const SubmenuView({Key? key, required this.currentItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var c = Get.find<ControlController>().menu;
    var x = c.indexWhere((element) => element.title == currentItem);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // const MenuHeader(),
            // const SizedBox(height: 10),
            SizedBox(
              height: Get.width,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: c[x].subMenu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        (c[x].subMenu[index].subSubMenu.isNotEmpty)
                            ? Get.toNamed(Routes.COLLECTIONS,
                                arguments: c[x].subMenu[index].subSubMenu)
                            : Get.toNamed(Routes.COLLECTIONS,
                                arguments: c[x].subMenu);
                      },
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (c[x]
                                        .subMenu[index]
                                        .title!
                                        .toLowerCase()
                                        .contains("on going") ||
                                    c[x]
                                        .subMenu[index]
                                        .title!
                                        .toLowerCase()
                                        .contains("special"))
                                ? SvgPicture.asset(
                                    "assets/icon/menu/sale.svg",
                                    height: 38,
                                    width: 38,
                                  )
                                : SvgPicture.asset(
                                    // "assets/icon/menu/${c[x].title!.toLowerCase()}_${c[x].subMenu[index].title!.toLowerCase()}.svg",
                                    "assets/icon/menu/men_men.svg",
                                    height: 38,
                                    width: 38,
                                  ),
                            const SizedBox(height: 10),
                            CustomText(
                              text: c[x]
                                  .subMenu[index]
                                  .title!
                                  .replaceAll("- New Arrival", ""),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              textOverflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                                "Collection: ${c[x].subMenu[index].subSubMenu.length.toString()}")
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
