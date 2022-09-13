class Announcement {
  String? icon;
  String? deskripsi;

  Announcement(this.icon, this.deskripsi);

  Announcement.fromJson(var json) {
    icon = json['icon'];
    deskripsi = json['deskripsi'];
  }
}
