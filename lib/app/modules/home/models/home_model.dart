class Sliders {
  int? id;
  String? title;
  String? images;

  Sliders({
    this.id,
    this.title,
    this.images,
  });

  Sliders.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    images = json['images'];
  }
}

class Category {
  int? id;
  String? title;
  String? image;
  String? subject;
  int? subjectID;

  Category({
    this.id,
    this.title,
    this.image,
    this.subject,
    this.subjectID,
  });

  Category.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    image = json['images'];
    subject = json['subject'];
    subjectID = json['subject_id'];
  }
}

class Collections {
  int? id;
  int? subjectid;
  String? title;
  String? deskripsi;
  String? images;

  Collections({
    this.id,
    this.subjectid,
    this.title,
    this.deskripsi,
    this.images,
  });

  Collections.fromJson(var json) {
    id = json['id'];
    subjectid = json['subjectid'];
    title = json['title'];
    deskripsi = json['deskripsi'];
    images = json['images'];
  }
}
