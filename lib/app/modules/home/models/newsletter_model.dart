class Newsletter {
  String? image;
  String? title;
  String? subtitle;
  String? deskripsi;

  Newsletter(this.image, this.title, this.subtitle, this.deskripsi);

  Newsletter.fromJson(var json) {
    image = json['image'];
    title = json['title'];
    subtitle = json['subtitle'];
    deskripsi = json["deskripsi"];
  }

  Newsletter.isEmpty();
}
