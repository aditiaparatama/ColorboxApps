import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncementHome extends StatelessWidget {
  const AnnouncementHome(
      {Key? key, required this.controller, this.pTop = 0, this.pBottom = 16})
      : super(key: key);

  final HomeController controller;
  final double pTop;
  final double pBottom;

  @override
  Widget build(BuildContext context) {
    bool warning = controller.maintenance;
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 135,
      ),
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemCount: controller.announcementHome.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 16, right: 16, top: pTop, bottom: pBottom),
              child: Container(
                decoration: BoxDecoration(
                  color: (warning) ? colorBoxWarning : colorBoxInfo,
                  border: Border.all(
                      color:
                          (warning) ? colorBorderWarning : Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 16.0,
                        child: SvgPicture.network(
                            controller.announcementHome[i].icon!),
                        backgroundColor: Colors.transparent,
                      ),
                      Container(
                        width: Get.width - 84,
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.announcementHome[i].title != "")
                              CustomText(
                                text: controller.announcementHome[i].title,
                                fontSize: 12,
                                textOverflow: TextOverflow.fade,
                                fontWeight: FontWeight.bold,
                              ),
                            CustomText(
                              text: controller.announcementHome[i].deskripsi,
                              fontSize: 12,
                              textOverflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
