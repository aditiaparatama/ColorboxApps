class Announcement {
  String? icon;
  String? title;
  String? deskripsi;
  String? type;

  Announcement(this.icon, this.title, this.deskripsi, this.type);

  Announcement.fromJson(var json) {
    icon = json['icon'];
    title = (json.containsKey("title")) ? json['title'] : "";
    deskripsi =
        json.containsKey("summary") ? json["summary"] : json["deskripsi"];
    type = json.containsKey("type") ? json["type"] : null;
  }
}
