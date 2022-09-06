class Home {
  int? id;
  String? title;
  String? images;
  // String? subject;
  // int? subjectID;
  // List<SubMenu> subMenu = List<SubMenu>.empty();

  Home({
    this.id,
    this.title,
    this.images,
    // this.subject,
    // this.subjectID,
    // required this.subMenu
  });

  Home.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    images = json['images'];
    // subject = json['subject'];
    // subjectID = json['subject_id'];
    // subMenu = [];
    // for (int i = 0; i < json['items'].length; i++) {
    //   // print(json['items'][i]);
    //   subMenu.add(SubMenu.fromJson(json['items'][i]));
    // }
  }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['title'] = title;
  //   data['images'] = image;
  //   data['subject'] = subject;
  //   data['subject_id'] = subjectID;
  //   return data;
  // }
}
