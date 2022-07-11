import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Get.width,
              child: ListView.separated(
                  separatorBuilder: (_, index) => const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Divider(),
                      ),
                  itemCount: c[curIndex].subMenu.length,
                  itemBuilder: (BuildContext _, int index) {
                    return GestureDetector(
                      onTap: () {
                        (c[curIndex].subMenu[index].subSubMenu.isNotEmpty)
                            ? Get.toNamed(Routes.COLLECTIONS,
                                arguments:
                                    c[curIndex].subMenu[index].subSubMenu)
                            : Get.toNamed(Routes.COLLECTIONS,
                                arguments: c[curIndex].subMenu);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListTile(
                          title: CustomText(
                            text: c[curIndex]
                                .subMenu[index]
                                .title!
                                .replaceAll("- New Arrival", "")
                                .toUpperCase(),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textOverflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: CustomText(
                              text:
                                  "Collection: ${c[curIndex].subMenu[index].subSubMenu.length.toString()}"),
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
