class OrderDetail {
  int id;
  String productSpecName;
  String dispName;
  String dispIcon;
  String requestedUser;
  String respondedUser;
  double pricePerUnit;
  int paymentsInDays;
  int deliveryInDays;
  String status;

  OrderDetail(
      {this.id,
      this.productSpecName,
      this.dispName,
      this.dispIcon,
      this.requestedUser,
      this.respondedUser,
      this.pricePerUnit,
      this.paymentsInDays,
      this.deliveryInDays,
      this.status});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['order_id'];
    productSpecName = json['product_spec_name'];
    dispName = json['disp_name'];
    dispIcon = json['disp_icon'];
    requestedUser = json['requested_user'];
    respondedUser = json['responded_user'];
    pricePerUnit = json['price_per_unit'];
    paymentsInDays = json['payments_in_days'];
    deliveryInDays = json['delivery_in_days'];
    status = json['status'];
  }
}
