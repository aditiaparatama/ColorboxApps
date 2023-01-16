import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarDefault extends StatelessWidget {
  final String text;
  final Icon? icon;
  final List<Widget>? actions;
  const AppBarDefault({Key? key, required this.text, this.icon, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: CustomText(
          text: text.toUpperCase(),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        leadingWidth: 36,
        leading: IconButton(
            padding: const EdgeInsets.all(16),
            onPressed: () => Get.back(),
            icon: (icon == null) ? const Icon(Icons.arrow_back) : icon!),
        actions: actions);
  }
}
