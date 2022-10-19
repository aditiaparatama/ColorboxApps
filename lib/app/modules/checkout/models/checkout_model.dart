import 'package:colorbox/app/data/models/discount_allocation.dart';
import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/collections/models/product_model.dart';

class CheckoutModel {
  String? id;
  AvailableShippingRates? availableShippingRates;
  CheckoutBuyerIdentity? buyerIdentity;
  String? completedAt;
  String? createdAt;
  Attribute? customAttributes;
  List<DiscountCodeApplication>? discountApplications;
  String? email;
  String? lineItemsSubtotalPrice;
  List<CheckoutLineItem>? lineItems;
  String? note;
  String? orderStatusUrl;
  String? paymentDueV2;
  bool? ready;
  bool? requiresShipping;
  MailingAddress? shippingAddress;
  List<DiscountAllocation>? shippingDiscountAllocations;
  ShippingRates? shippingLine;
  String? subtotalPriceV2;
  bool? taxExempt;
  bool? taxesIncluded;
  String? totalDuties;
  String? totalPriceV2;
  String? totalTaxV2;
  String? updatedAt;
  String? webUrl;

  CheckoutModel(
      this.id,
      this.availableShippingRates,
      this.buyerIdentity,
      this.completedAt,
      this.createdAt,
      this.customAttributes,
      this.email,
      this.lineItemsSubtotalPrice,
      this.lineItems,
      this.note,
      this.orderStatusUrl,
      this.paymentDueV2,
      this.ready,
      this.requiresShipping,
      this.shippingAddress,
      this.shippingDiscountAllocations,
      this.shippingLine,
      this.subtotalPriceV2,
      this.taxExempt,
      this.taxesIncluded,
      this.totalDuties,
      this.totalPriceV2,
      this.totalTaxV2,
      this.updatedAt,
      this.webUrl);

  CheckoutModel.fromJson(var json) {
    id = json['id'];
    availableShippingRates =
        AvailableShippingRates.fromJson(json['availableShippingRates']);
    buyerIdentity = CheckoutBuyerIdentity.fromJson(json['buyerIdentity']);
    completedAt = json['completedAt'];
    createdAt = json['createdAt'];

    discountApplications = [];

    for (final x in json['discountApplications']['edges']) {
      discountApplications!.add(DiscountCodeApplication.fromJson(x['node']));
    }

    email = json['email'];
    lineItemsSubtotalPrice = json['lineItemsSubtotalPrice']['amount'];
    lineItems = [];

    if (json['lineItems']['edges'].length > 0) {
      for (int i = 0; i < json['lineItems']['edges'].length; i++) {
        lineItems!.add(
            CheckoutLineItem.fromJson(json['lineItems']['edges'][i]['node']));
      }
    }

    note = json['note'];
    orderStatusUrl = json['orderStatusUrl'];
    paymentDueV2 = json['paymentDueV2']['amount'];
    ready = json['ready'];
    requiresShipping = json['requiresShipping'];
    shippingAddress = MailingAddress.fromJson(json['shippingAddress']);
    shippingDiscountAllocations = [];
    if (json['shippingDiscountAllocations'].length > 0) {
      shippingDiscountAllocations!.add(
          DiscountAllocation.fromJson(json['shippingDiscountAllocations']));
    }
    shippingLine = (json['shippingLine'] == null)
        ? null
        : ShippingRates.fromJson(json['shippingLine']);
    subtotalPriceV2 = json['subtotalPriceV2']['amount'];
    taxExempt = json['taxExempt'];
    taxesIncluded = json['taxesIncluded'];
    totalDuties = json['totalDuties'];
    totalPriceV2 = json['totalPriceV2']['amount'];
    totalTaxV2 = json['totalTaxV2'];
    updatedAt = json['updatedAt'];
    webUrl = json['webUrl'];
  }

  CheckoutModel.isEmpty() {
    lineItems = [];
  }

  Map<String, dynamic> toJson() {
    var items = [];
    for (int i = 0; i < lineItems!.length; i++) {
      items.add({
        "name": lineItems![i].variants!.titleProduct,
        "sku": lineItems![i].variants!.sku,
        "quantity": lineItems![i].quantity,
        "grams": lineItems![i].variants!.weight! * 1000,
        "price": double.parse(lineItems![i].variants!.price!),
        "requires_shipping": true,
        "variant_id": lineItems![i]
            .variants!
            .id!
            .replaceAll("gid://shopify/ProductVariant/", "")
      });
    }
    return {
      "rate": {
        "origin": {
          "country": "ID",
          "postal_code": "16820", //gudang delami
          "city": "Bekasi",
          "name": "Delamibrands"
        },
        "destination": {
          "country": "ID",
          "postal_code": shippingAddress!.zip,
          "city": shippingAddress!.city,
          "name": shippingAddress!.firstName
        },
        "items": items,
        "currency": "IDR",
        "locale": "en"
      }
    };
  }
}

class AvailableShippingRates {
  bool? ready;
  List<ShippingRates>? shippingRates;

  AvailableShippingRates(this.ready, this.shippingRates);

  AvailableShippingRates.fromJson(var json) {
    ready = json['ready'] ?? false;
    shippingRates = [];

    if (json['shippingRates'] != null) {
      for (int i = 0; i < json['shippingRates'].length; i++) {
        shippingRates!.add(ShippingRates.fromJson(json['shippingRates'][i]));
      }
    }
  }
}

class ShippingRates {
  String? handle;
  String? amount;
  String? title;
  String? etd;

  ShippingRates(this.handle, this.amount, this.title, this.etd);

  ShippingRates.fromJson(var json) {
    handle = json['handle'];
    amount = json['priceV2']['amount'];
    title = json['title'];
  }
}

class CheckoutBuyerIdentity {
  String? countryCode;

  CheckoutBuyerIdentity(this.countryCode);

  CheckoutBuyerIdentity.fromJson(var json) {
    countryCode = json['countryCode'];
  }
}

class Attribute {
  String? key;
  String? value;

  Attribute(this.key, this.value);

  Attribute.isEmpty() {
    key = "";
    value = "";
  }
}

class CheckoutLineItem {
  Attribute? customAttributes;
  List<DiscountAllocation>? discountAllocations;
  String? id;
  int? quantity;
  String? title;
  String? unitPrice;
  Variants? variants;

  CheckoutLineItem(this.customAttributes, this.discountAllocations, this.id,
      this.quantity, this.title, this.unitPrice, this.variants);

  CheckoutLineItem.fromJson(var json) {
    discountAllocations = [];

    if (json['discountAllocations'].length > 0) {
      for (int i = 0; i < json['discountAllocations'].length; i++) {
        discountAllocations!
            .add(DiscountAllocation.fromJson(json['discountAllocations'][i]));
      }
    }

    id = json['id'];
    quantity = json['quantity'];
    title = json['title'];
    unitPrice = json['unitPrice'];
    variants = Variants.fromCart(json['variant']);
  }
}

class CheckoutItems {
  String? variantId;
  int? quantity;
  Attribute? customAttributes;
  CheckoutItems(this.variantId, this.quantity);

  CheckoutItems.setItems(var json) {
    variantId = json.merchandise.id;
    quantity = json.quantity;
  }

  CheckoutItems.isEmpty();
}

class DiscountCodeApplication {
  String? typename;
  String? code;
  String? title;
  String? targetSelection;
  String? targetType;
  String? allocationMethod;
  String? amount;
  String? percentage;

  DiscountCodeApplication(
      this.code,
      this.amount,
      this.percentage,
      this.typename,
      this.targetSelection,
      this.targetType,
      this.allocationMethod);

  DiscountCodeApplication.empty();

  DiscountCodeApplication.fromJson(var json) {
    typename = json['__typename'];
    targetSelection = json['targetSelection'];
    targetType = json['targetType'];
    allocationMethod = json['allocationMethod'];

    if (typename == "DiscountCodeApplication") {
      code = json['code'];
    }

    if (typename == "AutomaticDiscountApplication") {
      title = json['title'];
    }

    if (json['value']['__typename'] == "MoneyV2") {
      amount = json['value']['amount'] ?? "0.0";
      percentage = "0.0";
    }

    if (json['value']['__typename'] == "PricingPercentageValue") {
      amount = "0.0";
      percentage = json['value']['percentage'].toString();
    }
  }
}
