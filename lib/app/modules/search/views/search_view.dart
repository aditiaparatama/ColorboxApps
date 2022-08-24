import 'package:colorbox/app/modules/search/controllers/search_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class SearchView extends GetView<SearchController> {
  TextEditingController search = TextEditingController();
  final ScrollController _sControl = ScrollController();

  void onScroll() {
    double maxScroll = _sControl.position.maxScrollExtent;
    double currentScroll = _sControl.position.pixels;

    if (currentScroll == maxScroll &&
        controller.product[controller.product.length - 1].hasNextPage!) {
      if (!controller.nextLoad.value) {
        controller.fetchAddSearchProduct(search.text);
        controller.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _sControl.addListener(onScroll);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: searchWidget(context),
          centerTitle: true,
        ),
        body: GetBuilder<SearchController>(
            init: Get.put(SearchController()),
            builder: (control) {
              return (control.loading.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (control.product.isEmpty)
                      ? const Text("DATA NOT FOUND")
                      : Column(
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: MediaQuery.of(context).size.height *
                                    (controller.nextLoad.value ? .84 : .88),
                                child: GridView.builder(
                                    itemCount: control.product.length,
                                    controller: _sControl,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 0.6,
                                    ),
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () => Get.toNamed(Routes.PRODUCT,
                                            arguments: control.product[i]),
                                        child: ItemCard(
                                          title: control.product[i].title!,
                                          image: control.product[i].image[0],
                                          price: control
                                              .product[i].variants[0].price!
                                              .replaceAll(".00", ""),
                                          compareAtPrice: (control
                                                      .product[i]
                                                      .variants[0]
                                                      .compareAtPrice ==
                                                  null)
                                              ? "0"
                                              : control.product[i].variants[0]
                                                  .compareAtPrice!
                                                  .replaceAll(".00", ""),
                                          onPress: () {},
                                        ),
                                      );
                                    })),
                            controller.nextLoad.value
                                ? const Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
            }));
  }

  Container searchWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0, right: 10),
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: TextField(
        autofocus: true,
        controller: search,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey.shade400),
          labelText: "Search...",
          suffixIcon: IconButton(
            onPressed: () {
              controller.fetchSearchProduct(search.text);
              controller.update();
            },
            icon: Icon(Icons.search, color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
