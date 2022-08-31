import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/modules/settings/views/web_view.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:colorbox/app/modules/settings/views/web_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class CustomCard extends GetView<SettingsController> {
  final String? textHeader;
  final List<Items>? items;

  const CustomCard({
    Key? key,
    this.textHeader,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: textHeader,
              color: Colors.grey,
            ),
            customDivider(),
            for (final item in items!) ...[
              TextButton(
                style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 0),
                  alignment: Alignment.centerLeft,
                ),
                child: CustomText(text: item.title, fontSize: 16),
                onPressed: () =>
                    Get.to(WebViewPage(title: item.title, url: item.url)),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class Items {
  final String title;
  final String url;

  Items(this.title, this.url);
}
