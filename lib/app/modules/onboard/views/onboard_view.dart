import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/video_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/onboard_controller.dart';
import 'package:video_player/video_player.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class OnBoardView extends GetView<OnBoardController> {
  final SettingsController _settingsController = Get.put(SettingsController());
  late VideoPlayerController videoController = VideoPlayerController.network(
      'https://widget.delamibrands.com/colorbox/mobile/onboard.mp4');

  Future<void> initializeSettings() async {
    await _settingsController.getUser();

    if (_settingsController.userModel.displayName != null) {
      // Get.offNamed(Routes.CONTROLV2);
    }
    //Simulate other services for 3 seconds
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return waitingView();
          }
          videoController.play();
          return Scaffold(
            backgroundColor: Colors.grey,
            body: SafeArea(
              child: Stack(
                children: [
                  const VideoApp(),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.black.withOpacity(0.25)
                        ])),
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: SizedBox(
                            child: MaterialButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "Daftar Akun",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              onPressed: () => Get.toNamed(Routes.REGISTER),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: SizedBox(
                            child: MaterialButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "Masuk Akun",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Get.offNamed(Routes.PROFILE);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: MaterialButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Masuk sebagai tamu",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, right: 0, left: 4),
                                  child: SvgPicture.asset(
                                    "assets/icon/bx-arrow-right.svg",
                                    height: 24.0,
                                    width: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () => Get.offNamed(Routes.CONTROLV2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Scaffold waitingView() {
    return Scaffold(
        body: Center(child: Image.asset("assets/images/colorbox_logo.webp")));
  }
}
