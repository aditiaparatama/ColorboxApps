import 'package:colorbox/app/modules/control/sub_menu_model.dart';

class Menu {
  int? id;
  String? title;
  String? image;
  String? subject;
  int? subjectID;
  List<SubMenu> subMenu = List<SubMenu>.empty();

  Menu(
      {this.id,
      this.title,
      this.image,
      this.subject,
      this.subjectID,
      required this.subMenu});
  Menu.empty();
  Menu.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    image = json['images'];
    subject = json['subject'];
    subjectID = json['subject_id'];
    // subMenu = json['items'];
    subMenu = [];

    if (json['items'].length >= 1 && subjectID != null) {
      json['title'] = "Semua";
      if (title == "Special Collections") {
        json['images'] = json['items'][0]['images'];
      }
      subMenu.add(SubMenu.fromJson(json));
    }

    for (int i = 0; i < json['items'].length; i++) {
      // print(json['items'][i]);
      subMenu.add(SubMenu.fromJson(json['items'][i]));
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['images'] = image;
    data['subject'] = subject;
    data['subject_id'] = subjectID;
    return data;
  }
}
