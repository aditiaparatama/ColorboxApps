import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnnouncementHome extends StatelessWidget {
  const AnnouncementHome({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(238, 242, 246, 1),
          border: Border.all(
              width: 1.0, color: const Color.fromRGBO(238, 242, 246, 1)),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 16.0,
                child: SvgPicture.network(controller.announcementHome[0].icon!),
                backgroundColor: Colors.transparent,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: controller.announcementHome[0].deskripsi,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textOverflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
