import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/control/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  final String currentItem;
  final ValueChanged<String> onSelectedItem;

  // ignore: prefer_const_constructors_in_immutables
  MenuScreen(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var c = Get.find<ControlController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  IconButton(
                      onPressed: () => ZoomDrawer.of(context)!.close(),
                      icon: const Icon(Icons.close)),
                  GestureDetector(
                    onTap: () => onSelectedItem("Home"),
                    child: const Image(
                      image: NetworkImage(
                          'https://cdn.shopify.com/s/files/1/0584/9363/2674/files/new-Logo-bar.png?v=1654500845'),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: Get.height * .55,
            child: ListView.builder(
              itemCount: c.menu.length,
              itemBuilder: (context, index) =>
                  Center(child: buildMenuItem(c.menu[index])),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Logout")),
        ],
      )),
    );
  }

  Widget buildMenuItem(Menu item) => ListTileTheme(
        selectedColor: Colors.white,
        iconColor: Colors.black,
        child: ListTile(
          selectedTileColor: Colors.black,
          selected: item.title == currentItem,
          minLeadingWidth: 20,
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(
              Icons.circle,
              size: 10,
            ),
          ),
          title: Text(item.title!, style: const TextStyle(fontSize: 20)),
          onTap: () => onSelectedItem(item.title!),
        ),
      );
}
