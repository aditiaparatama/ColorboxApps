import 'package:colorbox/app/routes/app_pages.dart';
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
    return Scaffold(
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
                Get.offAllNamed(Routes.CONTROLV2);
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
    );
  }
}
