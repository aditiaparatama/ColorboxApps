import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadioColor extends StatefulWidget {
  final List<String>? listData;
  const CustomRadioColor({Key? key, required this.listData}) : super(key: key);

  @override
  createState() {
    return CustomRadioColorState();
  }
}

class CustomRadioColorState extends State<CustomRadioColor> {
  List<RadioModel> radioData = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.listData!.length; i++) {
      radioData.add(RadioModel(false, widget.listData![i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.listData!.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          //highlightColor: Colors.red,
          splashColor: Colors.blueAccent,
          onTap: () {
            Get.find<ProductController>().getSelectedValue(
                Get.find<ProductController>().variant!.options[0].value!,
                radioData[index].buttonText);
            setState(() {
              // ignore: avoid_function_literals_in_foreach_calls
              radioData.forEach((element) => element.isSelected = false);
              radioData[index].isSelected = true;
            });
          },
          child: RadioItem(radioData[index]),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  // ignore: prefer_const_constructors_in_immutables
  RadioItem(this._item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          Container(
            height: 18.0,
            width: 18.0,
            margin: const EdgeInsets.only(left: 1),
            child: const Center(),
            decoration: BoxDecoration(
              color: customColor(_item.buttonText),
              border: Border.all(
                  width: _item.isSelected ? 1.0 : 1.0,
                  color: _item.isSelected
                      ? customColor(_item.buttonText)
                      : Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

Color customColor(String color) {
  switch (color.toLowerCase()) {
    case "amber":
      return Colors.amber;
    case "amber accent":
      return Colors.amberAccent;
    case "brown":
      return Colors.brown;
    case "cyan":
      return Colors.cyan;
    case "green":
      return Colors.green;
    case "grey":
      return Colors.grey;
    case "indigo":
      return Colors.indigo;
    case "lime":
      return Colors.lime;
    case "orange":
      return Colors.orange;
    case "pink":
      return Colors.pink;
    case "purple":
      return Colors.purple;
    case "red":
      return Colors.red;
    case "teal":
      return Colors.teal;
    case "yellow":
      return Colors.yellow;
    case "white":
      return Colors.white;
    case "black":
      return Colors.black;
    case "transparent":
      return Colors.transparent;
    case "olive":
      return const Color(0xFFB2B266);
    case "maroon":
      return const Color(0xFF800000);
    case "navy":
      return const Color(0xFF0B0B45);
    default:
      return Colors.grey;
  }
}
