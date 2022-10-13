import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertStock(BuildContext context) async {
  return await showDialog(
        //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: const CustomText(
            text: 'Stok Tidak Tersedia',
            fontSize: 14,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          content: const CustomText(
            text:
                'Produk yang kamu pesan ada yang tidak tersedia, silahkan ubah pesanan',
            fontSize: 12,
            textOverflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                backgroundColor: colorTextBlack,
                color: Colors.white,
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  Get.until((route) => Get.currentRoute == "/cart");
                  await Get.find<CartController>().getCart2();
                },
                //return false when click on "No"
                text: 'Kembali',
                fontSize: 14,
                height: 48,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ) ??
      false; //if showDialouge had returned null, then return false
}
