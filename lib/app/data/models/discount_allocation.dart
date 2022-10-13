class DiscountAllocation {
  String? allocatedAmount;
  DiscountApplication? discountApplication;

  DiscountAllocation(this.allocatedAmount, this.discountApplication);

  DiscountAllocation.fromJson(var json) {
    allocatedAmount = json['allocatedAmount']['amount'];
    discountApplication =
        DiscountApplication.fromJson(json['discountApplication']);
  }
}

class DiscountApplication {
  String? typename;
  String? allocationMethod;
  String? targetSelection;
  String? targetType;
  String? value;
  String? percentage;

  DiscountApplication(this.typename, this.allocationMethod,
      this.targetSelection, this.targetType, this.value, this.percentage);

  DiscountApplication.fromJson(var json) {
    typename = json["__typename"];
    allocationMethod = json['allocationMethod'];
    targetSelection = json['targetSelection'];
    targetType = json['targetType'];
    if (json['value']['__typename'] == "MoneyV2") {
      value = json['value']['amount'];
    }

    if (json['value']['__typename'] == "PricingPercentageValue") {
      percentage = json['value']['percentage'].toString();
    }
  }
}
