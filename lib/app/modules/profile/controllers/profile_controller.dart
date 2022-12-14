import 'dart:convert';
import 'dart:math';
import 'package:colorbox/app/data/models/countries_model.dart';
import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/globalvar.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ProfileController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  final ValueNotifier _loading = ValueNotifier(false);
  late FirebaseAuth _firebaseAuth;
  ValueNotifier get loading => _loading;
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  UserModel _userFromAdmin = UserModel.isEmpty();
  UserModel get userFromAdmin => _userFromAdmin;
  bool? _showPassword = true, emailExist = false, emailAlert = false;
  bool? get showPassword => _showPassword;

  final DateTime? _showDateBirth = DateTime.now();
  DateTime? get showDateBirth => _showDateBirth;

  String? email, password, firstName, firstN, lastN, tglLahir, noTelp;

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

    if (result['customerUserErrors'].length > 0) {
      _loading.value = false;
      update();
      return "Alamat email atau password salah";
    } else {
      var user = await ProfileProvider()
          .getUser(result["customerAccessToken"]['accessToken']);
      _userModel = UserModel.fromJson(user);
      _userModel.expiresAt = result["customerAccessToken"]['expiresAt'];

      CustomerToken token = CustomerToken.json(result["customerAccessToken"]);
      token.id = _userModel.id;
      setToken(token);

      await getUserAdmin(user["id"]);

      setUser(userModel);

      // CartProvider().cartBuyerIdentityupdate(_cartController.idCart!,
      //     result["customerAccessToken"]['accessToken'], _userModel);

      Get.find<SettingsController>().getTotalOrders();
      _loading.value = false;
      update();
    }

    return "1";
  }

  Future<String> loginWithGoogle() async {
    _loading.value = true;
    update();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    if (googleUser == null) return "-1";

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    var result = await FirebaseAuth.instance.signInWithCredential(credential);

    if (result.additionalUserInfo?.profile?["email_verified"]) {
      var checkUser = await ProfileProvider()
          .checkExistUser(result.additionalUserInfo?.profile?["email"]);

      if (checkUser['customers']['edges'].length == 0) {
        // checkUser['customers']['edges'][0]['node']['id']
        await registerFromGoogle(result.additionalUserInfo?.profile);
      }

      checkUser = await ProfileProvider()
          .checkExistUser(result.additionalUserInfo?.profile?["email"]);

      _loading.value = true;

      if (checkUser['customers']['edges'].length > 0) {
        DateTime date = DateTime.now();
        DateTime exp = date.add(const Duration(days: 31));
        setToken(CustomerToken(checkUser['customers']['edges'][0]['node']['id'],
            googleAuth.accessToken, exp.toString()));
        await getUserAdmin(checkUser['customers']['edges'][0]['node']['id']);

        // var resultToken = await ProfileProvider()
        //     .login(result.additionalUserInfo?.profile?["email"], defaultPass);

        // CustomerToken token =
        //     CustomerToken.json(resultToken["customerAccessToken"]);
        // token.id = checkUser['customers']['edges'][0]['node']['id'];
        // setToken(token);

        return checkUser['customers']['edges'][0]['node']['id'];
      }
    }
    return "-1";
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String> loginWithApple() async {
    _loading.value = true;
    update();
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final result =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    if (result.user != null && result.user!.email != null) {
      var checkUser =
          await ProfileProvider().checkExistUser(result.user!.email!);

      if (checkUser['customers']['edges'].length == 0) {
        await registerFromGoogle({
          "email": result.user!.email,
          "given_name": (result.user!.displayName == null)
              ? result.user!.email
              : (appleCredential.givenName == null)
                  ? result.user!.email
                  : appleCredential.givenName,
          "family_name": (result.user!.displayName == null)
              ? ""
              : (appleCredential.familyName == null)
                  ? ""
                  : appleCredential.familyName
        });
      }
      checkUser = await ProfileProvider().checkExistUser(result.user!.email!);

      if (checkUser['customers']['edges'].length > 0) {
        DateTime date = DateTime.now();
        DateTime exp = date.add(const Duration(days: 2000));
        setToken(CustomerToken(checkUser['customers']['edges'][0]['node']['id'],
            appleCredential.identityToken, exp.toString()));
        await getUserAdmin(checkUser['customers']['edges'][0]['node']['id']);

        _loading.value = false;
        update();
        return checkUser['customers']['edges'][0]['node']['id'];
      }
    }
    _loading.value = false;
    update();
    return "-1";
  }

  Future<void> getUserAdmin(String id) async {
    var user = await ProfileProvider().getUserFromAdmin(id);
    _userFromAdmin = UserModel.fromAdmin(user);
    _userModel.note =
        _userFromAdmin.note?.toLowerCase().trim().replaceAll("birthday:", "");
    update();
  }

  Future<void> registerFromGoogle(dynamic user) async {
    await ProfileProvider().register(user?['email'].toLowerCase(), defaultPass,
        user?['given_name'], user?['family_name']);
  }

  Future<String> register() async {
    _loading.value = true;
    update();

    var inputname = firstName.toString();
    var inputname2 = inputname.split(" ");

    firstN = inputname2[0].toString();
    lastN = inputname2.length > 1 ? inputname2[1].toString() : '';

    var result = await ProfileProvider()
        .register(email!.toLowerCase(), password!, firstN!, lastN!);

    if (result["msg"] == "success") {
      if (tglLahir != null && tglLahir != "") {
        tglLahir = DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(tglLahir!.trim()));
      }
      var variables = {
        "input": {
          "email": email!.toLowerCase(),
          "phone": noTelp,
          "firstName": firstN,
          "id": result['id'],
          "lastName": lastN,
          "note":
              (tglLahir != null && tglLahir != "") ? "" : "Birthday: $tglLahir",
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
      // var result = await ProfileProvider().getUser(_token!.accessToken!);
      // _userModel = UserModel.fromJson(result);
      await getUserAdmin(_token!.id!);
      _userModel = _userFromAdmin;
    }
  }

  updateDefaultAddress(String id) async {
    _loading.value = true;
    update();
    _token = await localStorageData.getTokenUser;
    if (_token != null) {
      // var result = await ProfileProvider()
      //     .customerDefaultAddressUpdate(_token!.accessToken!, id);
      dynamic variables = {"addressId": id, "customerId": _userFromAdmin.id};
      var result = await ProfileProvider()
          .customerUpdateDefaultAddressByAdmin(variables);

      if (result['customerUpdateDefaultAddress']['userErrors'].length == 0) {
        fetchingUser();

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

    _address!.firstName = x[0];
    _address!.lastName = (x.length > 1) ? x[1] : "";

    if (x.length > 2) {
      _address!.firstName = x[0] + " " + x[1];
      _address!.lastName = x[2];
    }

    switch (_address!.province) {
      case "Sumatera Utara":
        _address!.province = 'North Sumatra';
        break;
      case "Sumatera Barat":
        _address!.province = 'West Sumatra';
        break;
      case "Sumatera Selatan":
        _address!.province = 'South Sumatra';
        break;
      default:
        _address!.province = _address!.province;
    }

    if (_token == null || _token!.id == null) {
      _token = await localStorageData.getTokenUser;
    }
    dynamic result;

    if (_token!.accessToken != null) {
      if (id == null) {
        dynamic address = {
          "customer_address": {
            "customer_id":
                _userFromAdmin.id!.replaceAll("gid://shopify/Customer/", ""),
            "first_name": _address!.firstName,
            "last_name": _address!.lastName,
            "company": "",
            "address1": _address!.address1,
            "address2": _address!.address2,
            "city": _address!.city,
            "province": _address!.province,
            "country": "Indonesia",
            "zip": _address!.zip,
            "phone": _address!.phone,
            "name": _address!.firstName! + " " + _address!.lastName!,
            "country_code": "ID",
            "country_name": "Indonesia"
          }
        };

        result = await ProfileProvider().addAddressByAdmin(
            _userFromAdmin.id!.replaceAll("gid://shopify/Customer/", ""),
            address);

        if (!result.containsKey("errors")) {
          flg = 1;
        }
      } else {
        dynamic addresses = [
          {
            "address1": _address!.address1,
            "address2": _address!.address2,
            "city": _address!.city,
            "company": _address!.company,
            "country": _address!.country,
            "countryCode": "ID",
            "firstName": _address!.firstName,
            "id": id,
            "lastName": _address!.lastName,
            "phone": _address!.phone,
            "province": _address!.province,
            "zip": _address!.zip
          }
        ];

        for (MailingAddress x in _userFromAdmin.addresses ?? []) {
          if (x.id != id) {
            addresses.add({
              "address1": x.address1,
              "address2": x.address2,
              "city": x.city,
              "company": x.company,
              "country": x.country,
              "countryCode": "ID",
              "firstName": x.firstName,
              "id": x.id,
              "lastName": x.lastName,
              "phone": x.phone,
              "province": x.province,
              "zip": x.zip
            });
          }
        }

        dynamic variables = {
          "input": {"addresses": addresses, "id": _userFromAdmin.id}
        };

        result =
            await ProfileProvider().customerAddressUpdateByAdmin(variables);

        if (result['userErrors'].length == 0) {
          flg = 1;
        }
      }
      // var result = (id == null)
      //     ? await ProfileProvider()
      //         .customerAddressCreate(_token!.accessToken!, _address!)
      //     : await ProfileProvider()
      //         .customerAddressUpdate(_token!.accessToken!, _address!, id);
      // if (result['customerUserErrors'].length == 0) {
      //   flg = 1;
      // }
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
      // var result = await ProfileProvider()
      //     .customerAddressDelete(_token!.accessToken!, id);
      var idAddress = id.split("?");
      var result = await ProfileProvider().deleteAddressByAdmin(
          _userFromAdmin.id!.replaceAll("gid://shopify/Customer/", ""),
          idAddress[0].replaceAll("gid://shopify/MailingAddress/", ""));

      if (result) {
        // if (result['customerAddressDelete']['customerUserErrors'].length == 0) {
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

  searchProvince(String value) async {
    if (_countries!.provinces!.isEmpty) {
      await fetchingProvince();
    }
    _province = _countries!.provinces!
        .where((e) => e.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    // update();
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
    // var result = await ProfileProvider().getUser(_token!.accessToken!);
    // _userModel = UserModel.fromJson(result);
    await getUserAdmin(_token!.id!);
    _userModel = _userFromAdmin;
    _loading.value = false;
    update();
  }

  Future<void> fetchingCity(String province) async {
    var result = await ProfileProvider().getCity(province);
    _wilayah = [];
    String? kota = "";
    for (final x in result ?? []) {
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
          "phone": noTelp,
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

  Future<int> checkEmail(String email) async {
    var result = await ProfileProvider().checkExistUser(email);
    emailExist = (result['customers']['edges'].length > 0) ? true : false;
    update();
    return result['customers']['edges'].length;
  }
}
