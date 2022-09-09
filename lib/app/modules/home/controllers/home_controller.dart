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

  String currentItem = 'Home';
  int curIndex = 0;

  @override
  void onInit() async {
    await fetchData();
    await getCategory();
    await getCollections();
    super.onInit();
  }

  Future<void> fetchData() async {
    var json = await HomeProvider().getSlider();
    _sliders = [];
    for (int i = 0; i < json.length; i++) {
      _sliders.add(Sliders.fromJson(json[i]));
    }
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

  Future<void> getCollections() async {
    var json = await HomeProvider().getCollections();
    _collections = [];
    for (int i = 0; i < json.length; i++) {
      _collections.add(Collections.fromJson(json[i]));
    }
    update();
  }
}
