class Schedule {
  int id;
  String date;
  double payment;
  String paymentPercentage;
  double delivery;
  String deliveryPercentage;

  Schedule(
      {this.id,
      this.date,
      this.payment,
      this.paymentPercentage,
      this.delivery,
      this.deliveryPercentage});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    payment = json['payment'];
    paymentPercentage = json['payment_percentage'];
    delivery = json['delivery'];
    deliveryPercentage = json['delivery_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['payment'] = this.payment;
    data['payment_percentage'] = this.paymentPercentage;
    data['delivery'] = this.delivery;
    data['delivery_percentage'] = this.deliveryPercentage;
    return data;
  }
}
