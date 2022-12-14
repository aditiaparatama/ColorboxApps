class Announcement {
  String? icon;
  String? title;
  String? deskripsi;

  Announcement(this.icon, this.title, this.deskripsi);

  Announcement.fromJson(var json) {
    icon = json['icon'];
    title = (json.containsKey("title")) ? json['title'] : "";
    deskripsi =
        json.containsKey("summary") ? json["summary"] : json["deskripsi"];
  }
}
