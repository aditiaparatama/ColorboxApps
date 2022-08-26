import 'package:colorbox/app/data/models/mailing_address.dart';

class Order {
  String? id;
  String? name;
  String? createdAt;
  List<String>? events;
  List<String>? tags;
  String? cancelReason;
  String? displayFinancialStatus;
  String? status;
  TotalPriceSet? totalPriceSet;
  MailingAddress? shippingAddress;
  ShippingLine? shippingLine;
  LineItems? lineItems;

  Order(
      this.id,
      this.name,
      this.createdAt,
      this.events,
      this.tags,
      this.cancelReason,
      this.displayFinancialStatus,
      this.status,
      this.totalPriceSet,
      this.shippingAddress,
      this.shippingLine,
      this.lineItems);

  Order.fromJson(var json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    events = [];
    for (final x in json['events']['edges']) {
      events!.add(x['node']['message']);
    }
    tags = [];
    for (final x in json['tags']) {
      tags!.add(x);
    }
    cancelReason = json['cancelReason'];
    displayFinancialStatus = json['displayFinancialStatus'];

    if (json['displayFinancialStatus'] == "PENDING") {
      status = "Menunggu Pembayaran";
    }

    if (json['displayFinancialStatus'] == "EXPIRED") {
      status = "Dibatalkan";
    }

    if (json['displayFinancialStatus'] == "PAID") {
      status = "Pembayaran Diterima";
    }

    if (tags!.contains("sudah_proses")) {
      status = "Diproses";
    }

    if (json['fulfillments'].length > 0 &&
        json['fulfillments']['status'] == "SUCCESS") {
      status = "Dikirim";
    }

    totalPriceSet = TotalPriceSet.fromJson(json['totalPriceSet']);

    shippingAddress = MailingAddress.fromOrder(json['shippingAddress']);
    shippingLine = ShippingLine.fromJson(json['shippingLine']);
    lineItems = LineItems.fromJson(json['lineItems']);
  }
}

class TotalPriceSet {
  String? presentmentMoney;
  String? shopMoney;

  TotalPriceSet(this.presentmentMoney, this.shopMoney);

  TotalPriceSet.fromJson(var json) {
    presentmentMoney = json['presentmentMoney']['amount'];
    shopMoney = json['shopMoney']['amount'];
  }
}

class ShippingLine {
  String? code;
  String? title;
  String? shippingRateHandle;
  TotalPriceSet? originalPriceSet;

  ShippingLine(
      this.code, this.shippingRateHandle, this.title, this.originalPriceSet);

  ShippingLine.fromJson(var json) {
    code = json['code'];
    title = json['title'];
    shippingRateHandle = json['shippingRateHandle'];
    originalPriceSet = TotalPriceSet.fromJson(json['originalPriceSet']);
  }
}

class LineItems {
  PageInfo? pageInfo;
  List<Item>? items;

  LineItems(this.pageInfo, this.items);

  LineItems.fromJson(var json) {
    pageInfo = PageInfo.fromJson(json['pageInfo']);
    items = [];
    for (final x in json['edges']) {
      items!.add(Item.fromJson(x['node']));
    }
  }
}

class PageInfo {
  bool? hasNextPage;
  String? endCursor;

  PageInfo(this.hasNextPage, this.endCursor);

  PageInfo.fromJson(var json) {
    hasNextPage = json["hasNextPage"];
    endCursor = json["endCursor"];
  }
}

class Item {
  String? title;
  String? variantTitle;
  int? quantity;
  TotalPriceSet? originalUnitPriceSet;
  TotalPriceSet? originalTotalSet;
  String? image;

  Item(this.title, this.variantTitle, this.quantity, this.originalUnitPriceSet,
      this.originalTotalSet, this.image);

  Item.fromJson(var json) {
    title = json['title'];
    variantTitle = json['variantTitle'];
    quantity = json['quantity'];
    originalUnitPriceSet = TotalPriceSet.fromJson(json['originalUnitPriceSet']);
    originalTotalSet = TotalPriceSet.fromJson(json['originalTotalSet']);
    image = json['image']['url'];
  }
}
