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
  Value? value;

  CustomerGets(this.appliesOnOneTimePurchase, this.appliesOnSubscription);

  CustomerGets.fromJson(var json) {
    appliesOnOneTimePurchase = json['appliesOnOneTimePurchase'];
    appliesOnSubscription = json['appliesOnSubscription'];
    value = json.containsKey("value") ? Value.fromBxgY(json["value"]) : null;
  }
}

class CustomerBuys {
  bool? appliesOnOneTimePurchase;
  bool? appliesOnSubscription;

  CustomerBuys(this.appliesOnOneTimePurchase, this.appliesOnSubscription);

  CustomerBuys.fromJson(var json) {
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
  String? summary;
  String? endsAt;
  String? discountClass;
  List<DiscountCollection>? collections;
  MinimumRequirement? minimumRequirement;
  CustomerGets? customerGets;
  CombineWith combineWith = CombineWith.isEmpty();

  DiscountAutomatic(
      this.typename,
      this.title,
      this.summary,
      this.endsAt,
      this.discountClass,
      this.minimumRequirement,
      this.customerGets,
      this.collections,
      this.combineWith);

  DiscountAutomatic.fromJson(var json) {
    typename = json["__typename"];
    title = json["title"];
    summary = (json.containsKey("summary")) ? json["summary"] : null;
    endsAt = json["endsAt"];
    discountClass = json["discountClass"];
    if (typename == "DiscountAutomaticBxgy") {
      minimumRequirement = MinimumRequirement.fromByBxgY(json);
    } else {
      minimumRequirement = (json.containsKey("minimumRequirement"))
          ? MinimumRequirement.fromJson(json["minimumRequirement"])
          : null;
    }
    combineWith = CombineWith.fromJson(json['combinesWith']);
    customerGets = CustomerGets.fromJson(json["customerGets"]);
    collections = [];
    if (json["customerGets"]["items"].containsKey("collections")) {
      if (json["customerGets"]["items"]["collections"]["edges"].length > 0) {
        for (final x in json["customerGets"]["items"]["collections"]["edges"]) {
          collections!.add(DiscountCollection.fromJson(x["node"]));
        }
      }
    }
  }
}

class CombineWith {
  bool orderDiscounts = false;
  bool productDiscounts = false;
  bool shippingDiscounts = false;

  CombineWith(
      this.orderDiscounts, this.productDiscounts, this.shippingDiscounts);

  CombineWith.isEmpty();

  CombineWith.fromJson(var json) {
    orderDiscounts =
        (json.containsKey("orderDiscounts")) ? json["orderDiscounts"] : false;
    productDiscounts = json["productDiscounts"];
    shippingDiscounts = json["shippingDiscounts"];
  }
}

class MinimumRequirement {
  String? typename;
  String? greaterThanOrEqualToQuantity;
  String? greaterThanOrEqualToSubtotal;
  Value? value;
  List<String>? collections;

  MinimumRequirement(this.typename, this.greaterThanOrEqualToQuantity,
      this.greaterThanOrEqualToSubtotal, this.value);

  MinimumRequirement.fromJson(var json) {
    typename = json["__typename"];

    if (typename == "DiscountMinimumQuantity") {
      greaterThanOrEqualToQuantity = json["greaterThanOrEqualToQuantity"];
    } else {
      greaterThanOrEqualToSubtotal =
          json["greaterThanOrEqualToSubtotal"]["amount"];
    }
    collections = [];
  }

  MinimumRequirement.fromByBxgY(var json) {
    typename = json["__typename"];
    value = Value.fromBxgY(json["customerBuys"]["value"]);

    if (value!.typename == "DiscountPurchaseAmount") {
      greaterThanOrEqualToSubtotal = value!.amount;
    } else {
      greaterThanOrEqualToQuantity = value!.quantity!;
    }
    collections = [];
    for (final x in json["customerBuys"]["items"]["collections"]["edges"]) {
      collections!.add(x["node"]["id"]);
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

class Value {
  String? typename;
  String? amount;
  String? quantity;
  Effect? effect;

  Value(this.typename, this.amount, this.quantity);

  Value.fromBxgY(var json) {
    typename = json["__typename"];
    if (typename == "DiscountPurchaseAmount") {
      amount = json["amount"];
    } else if (typename == "DiscountAmount") {
      amount = json["amount"]["amount"].replaceAll(".0", "");
    } else {
      quantity = (json["quantity"].containsKey("quantity"))
          ? json["quantity"]["quantity"]
          : json["quantity"];
    }
    effect =
        json.containsKey("effect") ? Effect.fromJson(json["effect"]) : null;
  }
}

class Effect {
  String? typename;
  double? percentage;

  Effect(this.typename, this.percentage);

  Effect.fromJson(var json) {
    typename = json["__typename"];
    percentage = json["percentage"];
  }
}
