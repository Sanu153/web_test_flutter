class RequestResponder {
  int id;
  String partyName;
  String partyType;
  String productType;
  String productSpec;
  String market;
  double pricePerUnit;
  double quantity;
  int paymentsInDays;
  int deliveryInDays;

  RequestResponder(
      {this.id,
      this.partyName,
      this.partyType,
      this.productType,
      this.productSpec,
      this.market,
      this.pricePerUnit,
      this.quantity,
      this.paymentsInDays,
      this.deliveryInDays});

  RequestResponder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    partyName = json['party_name'];
    partyType = json['party_type'];
    productType = json['product_type'];
    productSpec = json['product_spec'];
    market = json['market'];
    pricePerUnit = json['price_per_unit'];
    quantity = json['quantity'];
    paymentsInDays = json['payments_in_days'];
    deliveryInDays = json['delivery_in_days'];
  }
}
