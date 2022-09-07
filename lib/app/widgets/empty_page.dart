import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyPage extends StatelessWidget {
  final Widget? image;
  final String? textHeader;
  final String? textContent;
  const EmptyPage({
    Key? key,
    this.image,
    this.textHeader,
    this.textContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
          ),
          image!,
          const SizedBox(
            height: 24,
          ),
          CustomText(
            text: textHeader,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(
            height: 8,
          ),
          CustomText(
            text: textContent,
            fontSize: 14,
            textOverflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
