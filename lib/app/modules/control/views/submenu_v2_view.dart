import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/search_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmenuV2View extends StatelessWidget {
  final int curIndex;
  const SubmenuV2View({Key? key, required this.curIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var c = Get.find<ControlController>().menu;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SearchCollection(),
      ),
      resizeToAvoidBottomInset: false,
      body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: c[curIndex].subMenu.length,
          itemBuilder: (BuildContext _, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.COLLECTIONS, arguments: {
                    "menu": c[curIndex].subMenu,
                    "indexMenu": index,
                    "sortBy": defaultSortBy
                  });
                },
                child: SizedBox(
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
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
            );
          }),
    );
  }
}
