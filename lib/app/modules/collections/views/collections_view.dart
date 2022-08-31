import 'package:colorbox/app/widgets/item_card.dart';
import '../controllers/collections_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CollectionsView extends GetView<CollectionsController> {
  var c = Get.arguments;
  final ScrollController _sControl = ScrollController();
  final ScrollController _sHorizontal = ScrollController();
  final PageController _pControl = PageController();

  void onScroll() {
    double maxScroll = _sControl.position.maxScrollExtent;
    double currentScroll = _sControl.position.pixels;

    if (currentScroll == maxScroll && controller.collection.hasNextPage!) {
      if (!controller.nextLoad.value) {
        controller.fetchAddCollectionProduct(controller.subjectID);
        controller.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchCollectionProduct(c[0].subjectID!, defaultSortBy);
    controller.subjectID = c[0].subjectID!;
    _sControl.addListener(onScroll);

    return GetBuilder<CollectionsController>(
        init: Get.put(CollectionsController()),
        builder: (control) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  "${control.collection.handle!.toUpperCase().replaceAll("-NEW-ARRIVAL", "").replaceAll("WOMEN-", "").replaceAll("MEN-", "")} (" +
                      control.collection.productsCount.toString() +
                      ")"),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CART);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: SvgPicture.asset("assets/icon/bx-cart.svg"),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                      controller: _sHorizontal,
                      scrollDirection: Axis.horizontal,
                      itemCount: c.length,
                      itemBuilder: (_, index) => buildCategory(index)),
                ),
                SizedBox(
                  height: Get.height * .84,
                  child: PageView.builder(
                      itemCount: c.length,
                      controller: _pControl,
                      onPageChanged: (index) {
                        controller.selectedIndex = index;
                        controller.subjectID = c[index].subjectID!;
                        controller.fetchCollectionProduct(
                            c[index].subjectID!, defaultSortBy);
                        controller.update();
                      },
                      itemBuilder: (context, index) {
                        return controller.loading.value
                            ? SizedBox(
                                height: Get.height * .5,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.black,
                                )),
                              )
                            : (control.collection.products.isEmpty)
                                ? SizedBox(
                                    height: Get.height * .5,
                                    child: const Center(
                                        child: Text("Data not found")))
                                : Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (controller.nextLoad.value
                                                    ? .8
                                                    : .84),
                                        child: GridView.builder(
                                            controller: _sControl,
                                            itemCount: control
                                                .collection.products.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 0.6,
                                            ),
                                            itemBuilder: (_, i) {
                                              return GestureDetector(
                                                onTap: () => Get.toNamed(
                                                    Routes.PRODUCT,
                                                    arguments: control
                                                        .collection
                                                        .products[i]),
                                                child: ItemCard(
                                                  title: control.collection
                                                      .products[i].title!,
                                                  image: control.collection
                                                      .products[i].image[0],
                                                  price: control
                                                      .collection
                                                      .products[i]
                                                      .variants[0]
                                                      .price!
                                                      .replaceAll(".00", ""),
                                                  compareAtPrice: (control
                                                              .collection
                                                              .products[i]
                                                              .variants[0]
                                                              .compareAtPrice ==
                                                          null)
                                                      ? "0"
                                                      : control
                                                          .collection
                                                          .products[i]
                                                          .variants[0]
                                                          .compareAtPrice!
                                                          .replaceAll(
                                                              ".00", ""),
                                                  onPress: () {},
                                                ),
                                              );
                                            }),
                                      ),
                                      controller.nextLoad.value
                                          ? const Center(
                                              child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Widget buildCategory(int index) {
    String title = c[index]
        .title!
        .toUpperCase()
        .replaceAll("- NEW ARRIVAL", "")
        .replaceAll("WOMEN - ", "")
        .replaceAll("MEN - ", "");
    var width = (title.length * 6);
    return GestureDetector(
      onTap: () {
        _pControl.jumpToPage(index);
        controller.selectedIndex = index;
        // controller.subjectID = c[index].subjectID!;
        // controller.fetchCollectionProduct(c[index].subjectID!);
        controller.update();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: (controller.selectedIndex == index)
                      ? Colors.black
                      : Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5 / 4),
              height: 2,
              width: width + .0,
              color: (controller.selectedIndex == index)
                  ? Colors.black
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
