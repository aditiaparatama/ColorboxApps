import 'package:colorbox/app/modules/collections/models/product_model.dart';

class Cart {
  String? id;
  DateTime? createdAt;
  List<DiscountCodes>? discountCodes;
  EstimatedCost? estimatedCost;
  String? note;
  List<Line>? lines;
  String? checkoutUrl;

  Cart(this.id, this.createdAt, this.discountCodes, this.estimatedCost,
      this.note, this.lines, this.checkoutUrl);

  Cart.fromJson(var json) {
    id = json["id"];
    createdAt = json["createdAt"];
    checkoutUrl = json["checkoutUrl"];
    discountCodes = [];
    for (int i = 0; i < json["discountCodes"].length; i++) {
      discountCodes!.add(DiscountCodes.fromJson(json["discountCodes"][i]));
    }
    estimatedCost = EstimatedCost.fromJson(json["estimatedCost"]);
    note = json["note"];
    lines = [];
    for (int i = 0; i < json["lines"]["edges"].length; i++) {
      lines!.add(Line.fromJson(json["lines"]["edges"][i]["node"]));
    }
  }

  Cart.empty() {
    lines = [];
  }
}

class DiscountCodes {
  bool? applicable;
  String? code;

  DiscountCodes(this.applicable, this.code);

  DiscountCodes.fromJson(var json) {
    applicable = json["applicable"];
    code = json["code"];
  }
}

class EstimatedCost {
  String? subtotalAmount;
  String? totalAmount;
  String? totalDutyAmount;
  String? totalTaxAmount;

  EstimatedCost(this.subtotalAmount, this.totalAmount, this.totalDutyAmount,
      this.totalTaxAmount);

  EstimatedCost.fromJson(var json) {
    subtotalAmount = json["subtotalAmount"]["amount"] ??= "0.0";
    totalAmount = json["totalAmount"]["amount"] ??= "0.0";
  }
}

class Line {
  String? id;
  Variants? merchandise;
  int? quantity;
  EstimatedCost? estimatedCost;
  DiscountAllocations? discountAllocations;
  String? attributes;

  Line(this.id, this.merchandise, this.quantity, this.estimatedCost,
      this.discountAllocations, this.attributes);

  Line.fromJson(var json) {
    id = json["id"];
    merchandise = Variants.fromCart(json["merchandise"]);
    quantity = json["quantity"];
    json["discountAllocations"].isEmpty
        ? discountAllocations = DiscountAllocations.empty()
        : discountAllocations =
            DiscountAllocations.fromJson(json["discountAllocations"][0]);
  }
}

class DiscountAllocations {
  String? title;
  String? amount;

  DiscountAllocations(this.title, this.amount);

  DiscountAllocations.fromJson(var json) {
    title = json['title'];
    amount = json["discountedAmount"]["amount"].toString();
  }

  DiscountAllocations.empty() {
    title = null;
    amount = null;
  }
}
