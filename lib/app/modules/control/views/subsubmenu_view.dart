import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class SubsubmenuView extends GetView {
  @override
  Widget build(BuildContext context) {
    var c = Get.arguments.subSubMenu;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: Get.width,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: c.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => Get.offNamed(Routes.COLLECTIONS,
                          arguments: c[index].subjectID!),
                      child: Card(
                        color: Colors.white,
                        child: Center(child: Text(c[index].title!)),
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
