import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String? title;
  final String? url;

  // ignore: prefer_const_constructors_in_immutables
  WebViewPage({Key? key, this.url, this.title}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();

  bool isLoading = true;
  int progressValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
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
              Map<String, String> headers = {
                "X-Shopify-Customer-Access-Token":
                    Get.find<SettingsController>().token!.accessToken ?? ""
              };
              webViewController.loadUrl(widget.url!, headers: headers);
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
                              color: Colors.black,
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
