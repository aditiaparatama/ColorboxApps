class Wishlist {
  int? count;
  String? type;
  dynamic items;
  String? message;

  Wishlist(this.count, this.type, this.items, this.message);

  Wishlist.fromJson(var json) {
    if (json == null) {
      items = [];
      return;
    }
    count = json['count'];
    type = json['type'];
    items = json['items'];
    message = json['message'];
  }

  Wishlist.empty();
}
