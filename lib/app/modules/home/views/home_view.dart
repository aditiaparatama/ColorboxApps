import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/home/views/sections/category_home.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/views/widgets/announcement_home.dart';
import 'package:colorbox/app/modules/home/views/widgets/carousel_slider.dart';
import 'package:colorbox/app/modules/home/views/widgets/home_header.dart';
import 'package:colorbox/app/modules/home/views/widgets/home_section.dart';
import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:colorbox/app/widgets/custom_appbar.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/custom_text_form_field.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/utilities/extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class HomeView extends GetView<HomeController> {
  TextEditingController search = TextEditingController();
  final ProfileController _profileController = Get.put(ProfileController());
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool emailAlert = false;
  Timer? _debounce;

  Future<bool> _showPopUp(context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            content: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: GetBuilder<HomeController>(builder: (_) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                                imageUrl: controller.newsletter.image!),
                            Positioned(
                                right: 0,
                                child: GestureDetector(
                                    onTap: () => Get.back(),
                                    child: SvgPicture.asset(
                                        "assets/icon/x-circle.svg")))
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 24),
                          child: Column(
                            children: [
                              CustomText(
                                text: (!controller.subscribe)
                                    ? controller.newsletter.title
                                    : "Terima Kasih Telah Berlangganan Colorbox",
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                textOverflow: TextOverflow.fade,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              CustomText(
                                text: (!controller.subscribe)
                                    ? controller.newsletter.subtitle
                                    : "Cek Emailmu Sekarang",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                textOverflow: TextOverflow.fade,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: (!controller.subscribe)
                                    ? controller.newsletter.deskripsi
                                    : "Special voucher 20% telah dikirim ke emailmu. Belanja sekarang dan gunakan vouchernya 🥳",
                                fontSize: 12,
                                textOverflow: TextOverflow.fade,
                                textAlign: TextAlign.center,
                              ),
                              if (!controller.subscribe) ...[
                                const SizedBox(height: 16),
                                Form(
                                  key: _formKey,
                                  child: CustomTextFormField(
                                    hint: "Email",
                                    textEditingController: emailController,
                                    onChange: (value) async {
                                      if (StringExtention(value)
                                          .isValidEmail()) {
                                        if (_debounce?.isActive ?? false) {
                                          _debounce?.cancel();
                                        }
                                        _debounce = Timer(
                                            const Duration(milliseconds: 300),
                                            () async {
                                          // do something with query
                                          await _profileController
                                              .checkEmail(value);
                                        });
                                      }
                                    },
                                    onSave: (value) {},
                                    validator: (value) {
                                      if (StringExtention(value)
                                          .isValidEmail()) {
                                        if (!_profileController.emailExist!) {
                                          emailAlert = true;
                                          return "Email belum terdaftar";
                                        }
                                        emailAlert = false;
                                        return null;
                                      }
                                      emailAlert = true;
                                      return "Format email salah";
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomButton(
                                  onPressed: () async {
                                    await _profileController
                                        .checkEmail(emailController.text);
                                    if (StringExtention(emailController.text)
                                        .isValidEmail()) {
                                      await _profileController
                                          .checkEmail(emailController.text);
                                    }

                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      await controller.customerSubscribe(
                                          emailController.text);
                                    }
                                  },
                                  backgroundColor: colorTextBlack,
                                  color: Colors.white,
                                  height: 45,
                                  text: "Berlangganan",
                                ),
                                const SizedBox(height: 12),
                                RichText(
                                    text: TextSpan(
                                  text:
                                      'Dengan berlangganan kamu setuju terhadap ',
                                  style: const TextStyle(
                                      color: colorTextBlack,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300),
                                  children: [
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrlString(
                                              "https://colorbox.co.id/pages/privacy-policy",
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                    ),
                                    const TextSpan(
                                      text: ' dan ',
                                    ),
                                    TextSpan(
                                        text: 'Terms & Condition',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            await launchUrlString(
                                                "https://colorbox.co.id/policies/terms-of-service",
                                                mode: LaunchMode
                                                    .externalApplication);
                                          })
                                  ],
                                )),
                              ],
                              if (controller.subscribe) ...[
                                const SizedBox(height: 16),
                                CustomButton(
                                  onPressed: () => Get.back(),
                                  backgroundColor: colorTextBlack,
                                  color: Colors.white,
                                  height: 45,
                                  text: "Belanja Sekarang",
                                ),
                              ]
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                })),
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      body: GetBuilder(
          init: Get.put(HomeController()),
          builder: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await _profileController.fetchingUser();
              if (controller.firstBuild &&
                  controller.newsletter.image != null &&
                  // ignore: unrelated_type_equality_checks
                  (_profileController.userModel.emailMarketing == null ||
                      _profileController
                              .userModel.emailMarketing!.marketingState !=
                          "SUBSCRIBED")) {
                controller.firstBuild = false;
                _showPopUp(context);
              }
            });

            return SafeArea(
              child: (controller.sliders.isEmpty)
                  ? loadingCircular()
                  : (controller.collections.isEmpty)
                      ? loadingCircular()
                      : ListView(
                          children: [
                            const HomeSearch(),
                            const SizedBox(height: 24),
                            CarouselWithIndicator(controller: controller),
                            if (controller.announcementHome.isNotEmpty)
                              AnnouncementHome(controller: controller),
                            Container(color: colorDiver, height: 4),
                            const SizedBox(height: 24),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CustomText(
                                    text: "Kategori Pakaian",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 24),
                                  CategoryHomeView(),
                                ],
                              ),
                            ),
                            Container(color: colorDiver, height: 4),
                            const HomeSectionWidget()
                          ],
                        ),
            );
          }),
    );
  }
}
