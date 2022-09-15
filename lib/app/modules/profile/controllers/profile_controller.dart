import 'package:colorbox/app/data/models/countries_model.dart';
import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/cart/providers/cart_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  final ValueNotifier _loading = ValueNotifier(false);
  ValueNotifier get loading => _loading;
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  UserModel _userFromAdmin = UserModel.isEmpty();
  UserModel get userFromAdmin => _userFromAdmin;
  bool? _showPassword = true;
  bool? get showPassword => _showPassword;

  final DateTime? _showDateBirth = DateTime.now();
  DateTime? get showDateBirth => _showDateBirth;

  String? email, password, firstName, firstN, lastN, tglLahir;

  //Update Address
  final MailingAddress? _address = MailingAddress.isEmpty();
  MailingAddress? get address => _address;
  CustomerToken? _token = CustomerToken.isEmpty();
  Countries? _countries;
  Countries? get countries => _countries;
  List<Province>? _province;
  List<Province>? get province => _province;
  dynamic _wilayah = [];
  dynamic _wilayahTemp = [];
  dynamic get wilayah => _wilayah;
  dynamic _kecamatan = [];
  dynamic _kecamatanTemp = [];
  dynamic get kecamatan => _kecamatan;
  dynamic _kodePos = [];
  dynamic _kodePosTemp = [];
  dynamic get kodePos => _kodePos;

  final CartController _cartController = Get.find<CartController>();

  @override
  void onInit() async {
    await fetchingUser();
    await fetchingProvince();
    super.onInit();
  }

  Future<String> login() async {
    _loading.value = true;
    update();
    var result = await ProfileProvider().login(email!, password!);
    CustomerToken token = CustomerToken.json(result["customerAccessToken"]);

    if (result['customerUserErrors'].length > 0) {
      _loading.value = false;
      update();
      return "Email/ Password tidak valid";
    } else {
      setToken(token);
      var user = await ProfileProvider()
          .getUser(result["customerAccessToken"]['accessToken']);
      _userModel = UserModel.fromJson(user);
      _userModel.expiresAt = result["customerAccessToken"]['expiresAt'];
      await getUserAdmin(user["id"]);

      setUser(userModel);

      CartProvider().cartBuyerIdentityupdate(_cartController.idCart!,
          result["customerAccessToken"]['accessToken'], _userModel);

      _loading.value = false;
      update();
    }

    return "1";
  }

  Future<void> getUserAdmin(String id) async {
    var user = await ProfileProvider().getUserFromAdmin(id);
    _userFromAdmin = UserModel.fromAdmin(user);
    _userModel.note =
        _userFromAdmin.note!.toLowerCase().trim().replaceAll("birthday:", "");
    update();
  }

  Future<String> register() async {
    _loading.value = true;
    update();

    var inputname = firstName.toString();
    var inputname2 = inputname.split(" ");

    firstN = inputname2[0].toString();
    lastN = inputname2.length > 1 ? inputname2[1].toString() : '';

    var result =
        await ProfileProvider().register(email!, password!, firstN!, lastN!);

    if (result["msg"] == "success") {
      tglLahir = DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd/MM/yyyy').parse(tglLahir!.trim()));
      var variables = {
        "input": {
          "email": email,
          "firstName": firstN,
          "id": result['id'],
          "lastName": lastN,
          "note": "Birthday: $tglLahir",
        }
      };
      await ProfileProvider().customerUpdate(variables);
      await login();
    }
    _loading.value = false;
    update();
    return result["msg"];
  }

  Future<String> forgotpassword() async {
    if (email != "") {
      var result = await ProfileProvider().forgotpassword(email!);
      _loading.value = false;
      update();
      return result;
    } else {
      _loading.value = false;
      update();

      return "";
    }
  }

  void setUser(UserModel userModel) async {
    await localStorageData.setUser(userModel);
  }

  void setToken(CustomerToken token) async {
    await localStorageData.setTokenUser(token);
  }

  void togglevisibility() {
    _showPassword = !_showPassword!;
    update();
  }

  Future<void> fetchingUser() async {
    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      var result = await ProfileProvider().getUser(_token!.accessToken!);
      _userModel = UserModel.fromJson(result);
      await getUserAdmin(_userModel.id!);
      update();
    }
  }

  updateDefaultAddress(String id) async {
    _loading.value = true;
    update();
    _token = await localStorageData.getTokenUser;
    if (_token != null) {
      var result = await ProfileProvider()
          .customerDefaultAddressUpdate(_token!.accessToken!, id);

      if (result['customerDefaultAddressUpdate']['customerUserErrors'].length ==
          0) {
        _userModel = UserModel.fromJson(
            result['customerDefaultAddressUpdate']['customer']);

        Get.snackbar("", "Alamat utama berhasil diubah",
            titleText: Row(
              children: [
                SvgPicture.asset(
                  "assets/icon/Check-Circle.svg",
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                const CustomText(
                  text: "Berhasil",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ],
            ),
            backgroundColor: colorTextBlack,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
      _loading.value = false;
      update();
    }
  }

  Future<int> saveAddress(String? id) async {
    int flg = 0;
    _loading.value = true;
    update();
    var x = _address!.firstName!.split(" ");

    if (x.length > 2) {
      _address!.firstName = x[0] + " " + x[1];
      _address!.lastName = x[2];
    }

    if (x.length > 1) {
      _address!.firstName = x[0];
      _address!.lastName = x[1];
    }

    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      var result = (id == null)
          ? await ProfileProvider()
              .customerAddressCreate(_token!.accessToken!, _address!)
          : await ProfileProvider()
              .customerAddressUpdate(_token!.accessToken!, _address!, id);
      if (result['customerUserErrors'].length == 0) {
        flg = 1;
      }
      _loading.value = false;
      update();
    }

    return flg;
  }

  deleteAddress(String id) async {
    _loading.value = true;
    update();
    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      var result = await ProfileProvider()
          .customerAddressDelete(_token!.accessToken!, id);

      if (result['customerAddressDelete']['customerUserErrors'].length == 0) {
        _userModel.addresses!.removeWhere((e) => e.id == id);

        Get.snackbar("", "Alamat berhasil dihapus",
            titleText: Row(
              children: [
                SvgPicture.asset(
                  "assets/icon/Check-Circle.svg",
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                const CustomText(
                  text: "Berhasil",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ],
            ),
            backgroundColor: colorTextBlack,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
      _loading.value = false;
      update();
    }
  }

  Future<void> fetchingProvince() async {
    var result = await ProfileProvider().getProvince();
    _countries = Countries.fromJson(result[0]);
    _province = _countries!.provinces!;
    update();
  }

  searchProvince(String value) {
    _province = _countries!.provinces!
        .where((e) => e.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  resetProvince() {
    if (_countries != null) {
      _province = _countries!.provinces!;
      update();
    }
  }

  getAddress() async {
    _loading.value = true;
    update();
    _token = await localStorageData.getTokenUser;
    var result = await ProfileProvider().getUser(_token!.accessToken!);
    _userModel = UserModel.fromJson(result);
    _loading.value = false;
    update();
  }

  Future<void> fetchingCity(String province) async {
    var result = await ProfileProvider().getCity(province);
    _wilayah = [];
    String? kota = "";
    for (final x in result) {
      if (x['kota'] != kota) {
        _wilayah.add({"kota": x['kota'], "kecamatan": []});

        final index =
            _wilayah.indexWhere((element) => element["kota"] == x["kota"]);

        if (index != -1) {
          _wilayah[index]['kecamatan'].add({
            "nama": x['kecamatan'],
            'kode_pos': [x['kode_pos']]
          });
        }
      } else {
        final index =
            _wilayah.indexWhere((element) => element["kota"] == x["kota"]);

        final index1 = _wilayah[index]['kecamatan']
            .indexWhere((element) => element["nama"] == x["kecamatan"]);

        if (index1 == -1) {
          _wilayah[index]['kecamatan'].add({
            "nama": x['kecamatan'],
            'kode_pos': [x['kode_pos']]
          });
        } else {
          _wilayah[index]['kecamatan'][index1]['kode_pos'].add(x['kode_pos']);
        }
      }
      kota = x['kota'];
    }
    _wilayahTemp = _wilayah;
    update();
  }

  searchWilayah(String value, String key) {
    if (key == "kota") {
      _wilayah = _wilayahTemp
          .where((e) =>
              e['kota'].toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
    }

    if (key == "kecamatan") {
      _kecamatan = {
        "kecamatan": _kecamatanTemp['kecamatan']
            .where((e) => e['nama']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList()
      };
    }
    if (key == "kode_pos") {
      _kodePos =
          _kodePosTemp.where((e) => e.toString().contains(value)).toList();
    }
    update();
  }

  Future<void> fetchingKecamatan(String kota) async {
    _kecamatan = _wilayahTemp.firstWhere((e) => e['kota'] == kota);
    _kecamatanTemp = _kecamatan;
    update();
  }

  Future<void> fetchingKodePos(String kec) async {
    _kodePos = _kecamatan['kecamatan'].firstWhere((e) => e['nama'] == kec);
    _kodePos = Set.of(_kodePos['kode_pos']).toList();
    _kodePosTemp = _kodePos;
    update();
  }

  Future<void> customerUpdate() async {
    loading.value = true;
    update();
    try {
      var x = firstName!.split(" ");

      if (x.length > 2) {
        firstN = x[0] + " " + x[1];
        lastN = x[2];
      }

      if (x.length > 1) {
        firstN = x[0];
        lastN = x[1];
      }
      tglLahir = DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd/MM/yyyy').parse(tglLahir!.trim()));
      var variables = {
        "input": {
          "email": email,
          "firstName": firstN,
          "id": userModel.id,
          "lastName": lastN,
          "note": "Birthday: $tglLahir",
        }
      };

      var result = await ProfileProvider().customerUpdate(variables);

      if (result['customerUpdate']['userErrors'].length >= 1) {
        Get.snackbar(
            "Error", result['customerUpdate']['userErrors'][0]["message"],
            backgroundColor: colorTextBlack,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        await fetchingUser();
        setUser(_userModel);

        Get.snackbar("", "Data berhasil diupdate",
            titleText: Row(
              children: [
                SvgPicture.asset(
                  "assets/icon/Check-Circle.svg",
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                const CustomText(
                  text: "Berhasil",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ],
            ),
            backgroundColor: colorTextBlack,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
    loading.value = false;
    update();
  }
}
