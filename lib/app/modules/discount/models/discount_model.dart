class Discount {
  bool? appliesOncePerCustomer;
  int? asyncUsageCount;
  CombinesWith? combinesWith;
  CustomerGets? customerGets;
  dynamic customerSelection;
  String? createdAt;
  String? endsAt;
  dynamic minimumRequirement;
  int? recurringCycleLimit;
  String? shortSummary;
  String? startsAt;
  String? status;
  String? summary;
  String? title;
  String? totalSales;
  int? usageLimit;

  Discount(
      this.appliesOncePerCustomer,
      this.asyncUsageCount,
      this.combinesWith,
      this.customerGets,
      this.customerSelection,
      this.createdAt,
      this.endsAt,
      this.minimumRequirement,
      this.recurringCycleLimit,
      this.shortSummary,
      this.startsAt,
      this.status,
      this.summary,
      this.title,
      this.totalSales,
      this.usageLimit);

  Discount.fromJson(var json) {
    appliesOncePerCustomer = json['appliesOncePerCustomer'];
    asyncUsageCount = json['asyncUsageCount'];
    combinesWith = CombinesWith.fromJson(json['combinesWith']);
    customerGets = CustomerGets.fromJson(json['customerGets']);
    customerSelection = json['customerSelection'];
    // if (json['customerSelection']['__typename'] == 'DiscountCustomerAll') {
    //   DiscountCustomerAll.fromJson(json['DiscountCustomerAll']);
    // }
    // if (json['customerSelection']['__typename'] == 'DiscountCustomerSegments') {
    //   DiscountCustomerSegments.fromJson(json['DiscountCustomerSegments']);
    // }
    // if (json['customerSelection']['__typename'] == 'DiscountCustomers') {
    //   DiscountCustomers.fromJson(json['DiscountCustomers']);
    // }

    createdAt = json['createdAt'];
    endsAt = json['endsAt'];
    minimumRequirement = json['minimumRequirement'];
    recurringCycleLimit = json['recurringCycleLimit'];
    shortSummary = json['shortSummary'];
    startsAt = json['startsAt'];
    status = json['status'];
    summary = json['summary'];
    title = json['title'];
    totalSales = null; //json['totalSales']['amount'];
    usageLimit = json['usageLimit'];
  }

  Discount.empty();
}

class CombinesWith {
  bool? orderDiscounts;
  bool? productDiscounts;
  bool? shippingDiscounts;

  CombinesWith(
      this.orderDiscounts, this.productDiscounts, this.shippingDiscounts);

  CombinesWith.fromJson(var json) {
    orderDiscounts = json['orderDiscounts'];
    productDiscounts = json['productDiscounts'];
    shippingDiscounts = json['shippingDiscounts'];
  }
}

class CustomerGets {
  bool? appliesOnOneTimePurchase;
  bool? appliesOnSubscription;

  CustomerGets(this.appliesOnOneTimePurchase, this.appliesOnSubscription);

  CustomerGets.fromJson(var json) {
    appliesOnOneTimePurchase = json['appliesOnOneTimePurchase'];
    appliesOnSubscription = json['appliesOnSubscription'];
  }
}

class DiscountCustomerAll {
  bool? allCustomers;

  DiscountCustomerAll(this.allCustomers);

  DiscountCustomerAll.fromJson(json) {
    allCustomers = json['allCustomers'];
  }
}

class DiscountCustomerSegments {
  Segments? segments;

  DiscountCustomerSegments(this.segments);

  DiscountCustomerSegments.fromJson(json) {
    segments = Segments.fromJson(json['segments']);
  }
}

class Segments {
  String? id;
  String? name;
  String? query;

  Segments(this.id, this.name, this.query);

  Segments.fromJson(json) {
    id = json['id'];
    name = json['name'];
    query = json['query'];
  }
}

class DiscountCustomers {
  List<String>? email;

  DiscountCustomers(this.email);

  DiscountCustomers.fromJson(json) {
    email = [];
    for (final x in json['customer']) {
      email!.add(x['email']);
    }
  }
}

class DiscountMinimumQuantity {
  int? greaterThanOrEqualToQuantity;

  DiscountMinimumQuantity(this.greaterThanOrEqualToQuantity);
}

class DiscountMinimumSubtotal {
  int? greaterThanOrEqualToSubtotal;

  DiscountMinimumSubtotal(this.greaterThanOrEqualToSubtotal);
}

class DiscountAutomatic {
  String? typename;
  String? title;
  List<DiscountCollection>? collections;
  MinimumRequirement? minimumRequirement;

  DiscountAutomatic(
      this.typename, this.title, this.minimumRequirement, this.collections);

  DiscountAutomatic.fromJson(var json) {
    typename = json["__typename"];
    title = json["title"];
    minimumRequirement =
        MinimumRequirement.fromJson(json["minimumRequirement"]);

    collections = [];
    if (json["customerGets"]["items"]["collections"]["edges"].length > 0) {
      for (final x in json["customerGets"]["items"]["collections"]["edges"]) {
        collections!.add(DiscountCollection.fromJson(x["node"]));
      }
    }
  }
}

class MinimumRequirement {
  String? typename;
  String? greaterThanOrEqualToQuantity;
  String? greaterThanOrEqualToSubtotal;

  MinimumRequirement(this.typename, this.greaterThanOrEqualToQuantity,
      this.greaterThanOrEqualToSubtotal);

  MinimumRequirement.fromJson(var json) {
    typename = json["__typename"];

    if (typename == "DiscountMinimumQuantity") {
      greaterThanOrEqualToQuantity = json["greaterThanOrEqualToQuantity"];
    } else {
      greaterThanOrEqualToSubtotal =
          json["greaterThanOrEqualToSubtotal"]["amount"];
    }
  }
}

class DiscountCollection {
  String? id;
  String? handle;

  DiscountCollection.empty();

  DiscountCollection(this.id, this.handle);

  DiscountCollection.fromJson(var json) {
    id = json["id"];
    handle = json["handle"];
  }
}
