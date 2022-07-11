import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/control/views/submenu_v2_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class CollectionList extends StatelessWidget {
  final PageController _pControl = PageController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlController>(
        init: Get.put(ControlController()),
        builder: (c) {
          return (c.listTabs.isEmpty)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : DefaultTabController(
                  length: c.listTabs.length,
                  child: Builder(builder: (context) {
                    final TabController tabController =
                        DefaultTabController.of(context)!;
                    return Scaffold(
                      appBar: AppBar(
                        title: const CustomText(
                          text: "COLLECTION",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        bottom: TabBar(
                          controller: tabController,
                          indicatorColor: Colors.black,
                          isScrollable: true,
                          tabs: c.listTabs,
                          onTap: (index) {
                            // c.curIndex = index;
                            // c.update();
                            _pControl.jumpToPage(index);
                          },
                        ),
                      ),
                      body: PageView.builder(
                          controller: _pControl,
                          itemCount: c.listTabs.length,
                          onPageChanged: (index) {
                            c.curIndex = index;
                            c.update();

                            tabController.index = index;
                          },
                          itemBuilder: (_, index) {
                            return SubmenuV2View(curIndex: c.curIndex);
                          }),
                    );
                  }));
        });
  }
}
