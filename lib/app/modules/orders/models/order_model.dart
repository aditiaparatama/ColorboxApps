import 'package:colorbox/app/data/models/mailing_address.dart';

class Order {
  PageInfo? pageInfo;
  String? id;
  String? name;
  String? createdAt;
  List<String>? events;
  List<String>? tags;
  String? cancelReason;
  String? displayFinancialStatus;
  String? status;
  int? subtotalLineItemsQuantity;
  TotalPriceSet? subtotalPriceSet;
  TotalPriceSet? totalPriceSet;
  MailingAddress? shippingAddress;
  ShippingLine? shippingLine;
  LineItems? lineItems;
  List<DiscountApplication>? discountApplications;
  TotalPriceSet? totalDiscountsSet;

  Order(
      this.pageInfo,
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
      this.lineItems,
      this.discountApplications);

  Order.fromJson(var json, var page) {
    pageInfo = PageInfo.fromJson(page);
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
      cancelReason =
          "Pesanan kamu dibatalkan karena sesi pembayaran telah habis.";
    }

    if (json['displayFinancialStatus'] == "PAID") {
      status = "Diproses";
    }

    if (tags!.contains("sudah_proses")) {
      status = "Diproses";
    }

    if (json['fulfillments'].length > 0) {
      if (json['fulfillments'][0]['status'] == "SUCCESS") {
        status = "Dikirim";
      }
    }

    if (json['cancelReason'] == "DECLINED") {
      status = "Dibatalkan";
      cancelReason =
          "Mohon maaf, pesanan kamu dibatalkan karena ada kesalahan pada sistem. Silahkan menghubungi customer service.";
    }

    if (json['cancelReason'] == "DECLINED" && tags!.contains("order_cod")) {
      status = "Dibatalkan";
      cancelReason =
          "Mohon maaf, pesanan kamu dibatalkan karena ada kesalahan pada sistem. Silahkan menghubungi customer service.";
    }

    subtotalLineItemsQuantity = json['subtotalLineItemsQuantity'];
    subtotalPriceSet = TotalPriceSet.fromJson(json['subtotalPriceSet']);
    totalPriceSet = TotalPriceSet.fromJson(json['totalPriceSet']);
    totalDiscountsSet = TotalPriceSet.fromJson(json['totalDiscountsSet']);

    shippingAddress = MailingAddress.fromOrder(json['shippingAddress']);
    shippingLine = ShippingLine.fromJson(json['shippingLine']);
    lineItems = LineItems.fromJson(json['lineItems']);

    discountApplications = [];
    for (final x in json['discountApplications']['edges']) {
      discountApplications!.add(
          (x['node']['__typename'] == "DiscountCodeApplication")
              ? DiscountApplication.fromCode(x['node'])
              : DiscountApplication.fromAutomatic(x['node']));
    }
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

  PageInfo.isEmpty() {
    hasNextPage = false;
  }
}

class Item {
  String? title;
  String? variantTitle;
  int? quantity;
  TotalPriceSet? originalUnitPriceSet;
  TotalPriceSet? originalTotalSet;
  String? image;
  List<DiscountAllocation>? discountAllocations;

  Item(this.title, this.variantTitle, this.quantity, this.originalUnitPriceSet,
      this.originalTotalSet, this.image, this.discountAllocations);

  Item.fromJson(var json) {
    title = json['title'];
    variantTitle = json['variantTitle'];
    quantity = json['quantity'];
    originalUnitPriceSet = TotalPriceSet.fromJson(json['originalUnitPriceSet']);
    originalTotalSet = TotalPriceSet.fromJson(json['originalTotalSet']);
    image = (json['image'] == null)
        ? "https://cdn.shopify.com/s/files/1/0423/9120/8086/files/Image.jpg?v=1661922597"
        : json['image']['url'];

    discountAllocations = [];
    for (final x in json['discountAllocations']) {
      discountAllocations!.add(DiscountAllocation.fromJson(x));
    }
  }
}

class DiscountAllocation {
  TotalPriceSet? allocatedAmountSet;
  DiscountApplication? discountApplication;

  DiscountAllocation(this.allocatedAmountSet, this.discountApplication);

  DiscountAllocation.fromJson(var json) {
    allocatedAmountSet = TotalPriceSet.fromJson(json['allocatedAmountSet']);
    discountApplication = (json['__typename'] == "DiscountCodeApplication")
        ? DiscountApplication.fromCode(json['discountApplication'])
        : DiscountApplication.fromAutomatic(json['discountApplication']);
  }
}

class DiscountApplication {
  String? typename;
  String? allocationMethod;
  String? targetSelection;
  String? targetType;
  String? value;
  String? percentage;
  String? title;

  DiscountApplication(
      this.allocationMethod, this.targetSelection, this.targetType, this.value);

  DiscountApplication.fromCode(var json) {
    typename = json['__typename'];
    allocationMethod = json['allocationMethod'];
    targetSelection = json['targetSelection'];
    targetType = json['targetType'];
    title = json['title'];

    if (json['value']['__typename'] == "MoneyV2") {
      value = json['value']['amount'];
    }

    if (json['value']['__typename'] == "PricingPercentageValue") {
      percentage = json['value']['percentage'].toString();
    }
  }

  DiscountApplication.fromAutomatic(var json) {
    typename = json['__typename'];
    allocationMethod = json['allocationMethod'];
    targetSelection = json['targetSelection'];
    targetType = json['targetType'];
    title = json['title'];
    if (json['value']['__typename'] == "MoneyV2") {
      value = json['value']['amount'];
    }

    if (json['value']['__typename'] == "PricingPercentageValue") {
      percentage = json['value']['percentage'].toString();
    }
  }
}
