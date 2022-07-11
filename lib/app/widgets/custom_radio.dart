import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadio extends StatefulWidget {
  final List<String>? listData;
  const CustomRadio({Key? key, required this.listData}) : super(key: key);

  @override
  createState() {
    return CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> radioData = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.listData!.length; i++) {
      radioData.add(RadioModel(
          false,
          widget.listData![i],
          Get.find<ProductController>().getStock(
              widget.listData![i],
              (Get.find<ProductController>().variant!.options.length > 1)
                  ? Get.find<ProductController>().variant!.options[1].value!
                  : "")));
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
                radioData[index].buttonText,
                (Get.find<ProductController>().variant!.options.length > 1)
                    ? Get.find<ProductController>().variant!.options[1].value!
                    : "");
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
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.symmetric(horizontal: 3),
            height: 45.0,
            width: 45.0,
            child: Center(
              child: Text(_item.buttonText,
                  style: TextStyle(
                      color: _item.stock == 0
                          ? Colors.black
                          : _item.isSelected
                              ? Colors.white
                              : Colors.black,
                      fontWeight: _item.isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16.0)),
            ),
            decoration: BoxDecoration(
              color: _item.stock == 0
                  ? const Color(0xFFf2f2f2)
                  : _item.isSelected
                      ? Colors.black
                      : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.black : Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(2.0)),
            ),
          ),
          _item.stock == 0
              ? RotationTransition(
                  turns: const AlwaysStoppedAnimation(-45 / 360),
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      color: const Color(0xFFe6e6e6),
                      height: 1,
                      width: 45,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final int stock;

  RadioModel(this.isSelected, this.buttonText, this.stock);
}
