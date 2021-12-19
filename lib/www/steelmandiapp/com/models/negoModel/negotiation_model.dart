class RespondNegotiation {
  int requestResponderId;
  int buySellRequestId;
  double price;
  double quantity;
  int paymentsInDays;
  int deliveryInDays;

  RespondNegotiation(
      {this.requestResponderId,
      this.buySellRequestId,
      this.price,
      this.quantity,
      this.paymentsInDays,
      this.deliveryInDays});

//  RespondNegotiation.fromJson(Map<String, dynamic> json) {
//    requestResponderId = json['request_responder_id'];
//    buySellRequestId = json['buy_sell_request_id'];
//    price = json['price'];
//    quantity = json['quantity'];
//    paymentsInDays = json['payments_in_days'];
//    deliveryInDays = json['delivery_in_days'];
//  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_responder_id'] = this.requestResponderId;
    data['buy_sell_request_id'] = this.buySellRequestId;
    data['price_per_unit'] = this.price;
    data['quantity'] = this.quantity;
    data['payments_in_days'] = this.paymentsInDays;
    data['delivery_in_days'] = this.deliveryInDays;
    return data;
  }
}
