import 'package:colorbox/app/modules/home/models/announcement_model.dart';
import 'package:colorbox/app/modules/home/providers/home_provider.dart';
import 'package:colorbox/app/modules/home/models/home_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<Sliders> _sliders = List<Sliders>.empty();
  List<Sliders> get sliders => _sliders;

  List<Category> _category = List<Category>.empty();
  List<Category> get category => _category;

  List<Collections> _collections = List<Collections>.empty();
  List<Collections> get collections => _collections;

  List<Announcement> _announcementHome = [];
  List<Announcement> get announcementHome => _announcementHome;

  List<Announcement> _announcementProduct = [];
  List<Announcement> get announcementProduct => _announcementProduct;

  bool _maintenance = false;
  bool get maintenance => _maintenance;

  String currentItem = 'Home';
  int curIndex = 0;

  @override
  void onInit() async {
    await fetchData();
    await getCategory();

    super.onInit();
  }

  Future<void> fetchData() async {
    var json = await HomeProvider().getHomeSettings();
    _sliders = [];
    _announcementHome = [];
    _announcementProduct = [];

    for (int i = 0; i < json['sliders']['items'].length; i++) {
      _sliders.add(Sliders.fromJson(json['sliders']['items'][i]));
    }

    _maintenance =
        (json.containsKey("maintenance")) ? json["maintenance"] : false;
    getCollections(json['CollectionsHome']['items']);
    getAnnouncementHome(json['announcementHome']);
    getAnnouncementProduct(json['announcementProduct']);

    update();
  }

  Future<void> getCategory() async {
    var json = await HomeProvider().getCategory();
    _category = [];
    for (int i = 0; i < json.length; i++) {
      _category.add(Category.fromJson(json[i]));
    }
    update();
  }

  getCollections(json) {
    // var json = await HomeProvider().getCollections();
    _collections = [];
    for (int i = 0; i < json.length; i++) {
      _collections.add(Collections.fromJson(json[i]));
    }
    update();
  }

  getAnnouncementHome(json) async {
    _announcementHome = [];
    for (int i = 0; i < json.length; i++) {
      _announcementHome.add(Announcement.fromJson(json[i]));
    }
    update();
  }

  getAnnouncementProduct(json) async {
    _announcementProduct = [];
    for (int i = 0; i < json.length; i++) {
      _announcementProduct.add(Announcement.fromJson(json[i]));
    }
    update();
  }
}
