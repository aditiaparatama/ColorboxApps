import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPaymentView extends StatefulWidget {
  final String? title;
  final String? url;

  // ignore: prefer_const_constructors_in_immutables
  WebPaymentView({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<WebPaymentView> createState() => _WebPaymentViewState();
}

class _WebPaymentViewState extends State<WebPaymentView> {
  bool isLoading = true;
  int progressValue = 0;

  @override
  Widget build(BuildContext context) {
    Future<bool> showAlert() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                height: 240,
                child: Column(
                  children: [
                    const CustomText(
                      text: 'Lakukan pembayaran?',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const CustomText(
                      text:
                          'Apakah Anda ingin meninggalkan halaman Pembayaran?',
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      textOverflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      backgroundColor: colorTextBlack,
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(false),
                      text: 'Tidak',
                      fontSize: 14,
                      width: Get.width,
                      height: 45,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      backgroundColor: Colors.white,
                      onPressed: () => Navigator.of(context).pop(true),
                      text: 'Ya',
                      fontSize: 14,
                      width: Get.width,
                      height: 45,
                    ),
                  ],
                ),
              ),
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: () async => await showAlert(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            centerTitle: false,
            elevation: 3,
            shadowColor: Colors.grey.withOpacity(0.3),
            leadingWidth: 36,
            leading: IconButton(
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  Get.until((route) => Get.currentRoute == "/controlv2");
                  Get.toNamed(Routes.ORDERS);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
        ),
        body: Stack(
          children: [
            WebView(
              // initialUrl: widget.url,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
              onProgress: (value) {
                setState(() {
                  progressValue = value;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                webViewController.loadUrl(widget.url!);
                // _controller.complete(webViewController);
              },
            ),
            isLoading
                ? Center(
                    child: SizedBox(
                      height: 200.0,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                color: colorTextBlack,
                                strokeWidth: 5,
                              ),
                            ),
                          ),
                          Center(child: Text(progressValue.toString() + "%")),
                        ],
                      ),
                    ),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}
