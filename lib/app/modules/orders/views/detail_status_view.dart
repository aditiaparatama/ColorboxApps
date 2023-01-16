import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DetailStatusView extends GetView<OrdersController> {
  final String noResi;
  const DetailStatusView(this.noResi, {Key? key}) : super(key: key);

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    await Fluttertoast.showToast(
        msg: "Nomor Resi sudah tersalin",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Detail Status",
            actions: [],
          )),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "No Resi",
                  color: Color(0xFF777777),
                ),
                InkWell(
                  onTap: () => _copyToClipboard(noResi),
                  child: Row(
                    children: [
                      CustomText(
                        text: noResi,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorNeutral100,
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: colorTextBlue,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 72,
                        child: CustomText(
                          text: controller.history[index].date,
                          textOverflow: TextOverflow.fade,
                          fontSize: 12,
                          textAlign: TextAlign.center,
                          color: (index == 0)
                              ? const Color(0xFF115AC8)
                              : const Color(0xFF777777),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Center(
                          child: Stack(
                            children: [
                              if (index != controller.history.length - 1)
                                Center(
                                  child: Container(
                                    color: const Color(0xFFE5E8EB),
                                    width: 1,
                                    constraints:
                                        const BoxConstraints(minHeight: 50),
                                  ),
                                ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: (index == 0)
                                        ? const Color(0xFF115AC8)
                                        : const Color(0xFFE5E8EB),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100))),
                                height: 10,
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: CustomText(
                          text: controller.history[index].desc,
                          textOverflow: TextOverflow.fade,
                          color: (index == 0)
                              ? const Color(0xFF115AC8)
                              : const Color(0xFF777777),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
