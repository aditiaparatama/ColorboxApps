import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HapusAkunNotice extends StatelessWidget {
  const HapusAkunNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: AppBarDefault(
            text: "",
          )),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: const [
            CustomText(
              text: "Pengajuan Dikirim",
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 16),
            CustomText(
              text:
                  "Pengajuan hapus akun kamu berhasil dikirim. Kami membutuhkan waktu 5-7 hari kerja untuk memproses pengajuanmu. Bila ada pertanyaan lebih lanjut, silahkan hubungi customer service kami",
              textOverflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            )
          ],
        ),
      )),
    );
  }
}
