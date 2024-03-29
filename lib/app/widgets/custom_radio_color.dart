import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomRadioColor extends StatefulWidget {
  final List<String>? listData;
  final ProductController controller;

  const CustomRadioColor(
      {Key? key, required this.listData, required this.controller})
      : super(key: key);

  @override
  createState() {
    return CustomRadioColorState();
  }
}

class CustomRadioColorState extends State<CustomRadioColor> {
  List<RadioModel> radioData = [];
  // final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.listData!.length; i++) {
      radioData.add(RadioModel((i == 0) ? true : false, widget.listData![i]));
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
            if (widget.listData!.length > 1) {
              widget.controller.getSelectedValue(
                  widget.controller.variant!.options[0].value!,
                  radioData[index].buttonText,
                  fromColor: true);
            }
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
            height: 24.0,
            width: 24.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: _item.isSelected ? colorNeutral100 : colorNeutral60,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Center(
              child: Container(
                height: 18.0,
                width: 18.0,
                child: const Center(),
                decoration: BoxDecoration(
                  color: customColors(_item.buttonText),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
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
