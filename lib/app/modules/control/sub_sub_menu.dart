class SubSubMenu {
  int? id;
  String? title;
  String? image;
  String? subject;
  int? subjectID;

  SubSubMenu({this.id, this.title, this.subject, this.subjectID});

  SubSubMenu.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    image = json['images'];
    subject = json['subject'];
    subjectID = json['subject_id'];
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
