import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/modules/settings/views/location_bottomsheet.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:colorbox/utilities/extension.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationStoreView extends GetView<SettingsController> {
  LocationStoreView({Key? key}) : super(key: key);

  final TextEditingController _city = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.indexSelectedRadio = null;
    controller.searchLocation = controller.locationStore;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "Lokasi Toko",
          )),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: GetBuilder<SettingsController>(builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autocorrect: false,
                controller: _city,
                readOnly: true,
                cursorColor: colorNeutral100,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Cari toko berdasarkan kota atau provinsi',
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                    color: colorNeutral70,
                  ),
                  suffixIcon: (_city.text.isNotEmpty)
                      ? IconButton(
                          onPressed: () {
                            _city.text = "";
                            controller.searchLocationStore("");
                          },
                          icon: const Icon(
                            Icons.cancel_sharp,
                            color: colorTextBlack,
                            size: 18,
                          ))
                      : const SizedBox(),
                ),
                onTap: () => bottomSheetProvinceStore(_city),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.searchLocation.length,
                      itemBuilder: (context, i) => GestureDetector(
                            onTap: () {
                              controller.indexSelectedRadio = i;
                              controller.update();
                            },
                            child: Container(
                              color: (controller.indexSelectedRadio == i)
                                  ? colorDiver
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                      (controller.indexSelectedRadio == i)
                                          ? "assets/icon/radio_select.svg"
                                          : "assets/icon/radio_unselect.svg"),
                                  const SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        text: controller
                                            .searchLocation[i].namaMallCegid!
                                            .toUpperCase(),
                                        fontSize: 14,
                                        color: colorNeutral100,
                                        fontWeight: FontWeight.w800,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      onlineWidget(controller
                                          .searchLocation[i].flgOpen!),
                                      const SizedBox(height: 4),
                                      Flexible(
                                        child: SizedBox(
                                          width: Get.width - 100,
                                          child: CustomText(
                                            text: StringExtention(controller
                                                    .searchLocation[i]
                                                    .alamatLengkap!)
                                                .toTitleCase(),
                                            fontSize: 12,
                                            textOverflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ),
                                      if (controller.indexSelectedRadio ==
                                          i) ...[
                                        const SizedBox(height: 12),
                                        detailInfo(i),
                                        const SizedBox(height: 12),
                                        GestureDetector(
                                          onTap: () async {
                                            final availableMaps =
                                                await MapLauncher.installedMaps;

                                            var koordinat = controller
                                                .searchLocation[i].latLong!
                                                .split(",");

                                            await availableMaps.first
                                                .showDirections(
                                                    destinationTitle: controller
                                                        .searchLocation[i]
                                                        .namaMallGoogle,
                                                    destination: Coords(
                                                        double.parse(
                                                            koordinat[0]),
                                                        double.parse(
                                                            koordinat[1])),
                                                    directionsMode:
                                                        DirectionsMode.driving,
                                                    originTitle: "My Location");
                                          },
                                          child: const CustomText(
                                            text: "Lihat di peta",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(0xFF114CD6),
                                          ),
                                        )
                                      ]
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                ),
              ),
            ],
          );
        }),
      )),
    );
  }

  Row detailInfo(int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Jam Operasional",
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            Row(
              children: [
                CustomText(
                  text: controller.searchLocation[i].opening,
                  fontSize: 12,
                  color: colorNeutral90,
                ),
                const CustomText(
                  text: " - ",
                  fontSize: 12,
                  color: colorNeutral90,
                ),
                CustomText(
                  text: controller.searchLocation[i].close,
                  fontSize: 12,
                  color: colorNeutral90,
                ),
              ],
            )
          ],
        ),
        const SizedBox(width: 50),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Kontak",
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(width: 101),
            CustomText(
              text: controller.searchLocation[i].phone,
              fontSize: 12,
              color: colorNeutral90,
            ),
          ],
        )
      ],
    );
  }

  Row onlineWidget(bool open) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: (open) ? const Color(0xFF3EB27A) : colorNeutral60,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
        ),
        const SizedBox(width: 4),
        CustomText(
          text: (open) ? "Buka" : "Tutup",
          fontSize: 12,
          color: colorNeutral90,
        )
      ],
    );
  }
}
