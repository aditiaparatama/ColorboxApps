import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/control/menu_model.dart';
import 'package:colorbox/app/modules/control/sub_menu_model.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/views/sections/collection1_home.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSectionWidget extends GetView<HomeController> {
  const HomeSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.collections.length,
            separatorBuilder: (context, index) {
              return Container(color: colorDiver, height: 4);
            },
            itemBuilder: (context, index) {
              return Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 24,
                      bottom:
                          (controller.collections[index].deskripsi == null ||
                                  controller.collections[index].deskripsi == "")
                              ? 16
                              : 8),
                  child: CustomText(
                    text: (controller.collections.isEmpty)
                        ? ""
                        : controller.collections[index].title!,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                (controller.collections[index].deskripsi == null ||
                        controller.collections[index].deskripsi == "")
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CustomText(
                          text: (controller.collections.isEmpty)
                              ? ""
                              : controller.collections[index].deskripsi!,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                (controller.collections[index].images == null ||
                        controller.collections[index].images == "")
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          var menu = Menu(
                              subMenu: List<SubMenu>.empty(),
                              title: controller.collections[index].title,
                              subjectID:
                                  controller.collections[index].subjectid!);
                          Get.toNamed(Routes.COLLECTIONS, arguments: {
                            "menu": menu,
                            "indexMenu": null,
                            "sortBy": 2
                          });
                        },
                        child: SizedBox(
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: controller.collections[index].images!,
                              fit: BoxFit.cover,
                              width: Get.width,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                CollectionHome1(
                    id: controller.collections[index].subjectid!, index: index),
              ]);
            }));
  }
}
