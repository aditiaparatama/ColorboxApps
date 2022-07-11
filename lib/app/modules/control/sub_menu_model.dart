import 'package:colorbox/app/modules/control/sub_sub_menu.dart';

class SubMenu {
  int? id;
  String? title;
  String? subject;
  int? subjectID;
  List<SubSubMenu> subSubMenu = List<SubSubMenu>.empty();

  SubMenu(
      {this.id,
      this.title,
      this.subject,
      this.subjectID,
      required this.subSubMenu});

  SubMenu.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    subject = json['subject'];
    subjectID = json['subject_id'];
    subSubMenu = [];
    for (int i = 0; i < json['items'].length; i++) {
      subSubMenu.add(SubSubMenu.fromJson(json['items'][i]));
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subject'] = subject;
    data['subject_id'] = subjectID;
    return data;
  }
}
