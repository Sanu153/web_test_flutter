class Adherence {
  int id;
  String date;
  double scheduledPayment;
  double scheduledDelivery;
  double todaysPayment;
  double todaysDelivery;

  Adherence(
      {this.id,
      this.date,
      this.scheduledPayment,
      this.scheduledDelivery,
      this.todaysPayment,
      this.todaysDelivery});

  Adherence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    scheduledPayment = json['scheduled_payment'];
    scheduledDelivery = json['scheduled_delivery'];
    todaysPayment = json['todays_payment'];
    todaysDelivery = json['todays_delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['scheduled_payment'] = this.scheduledPayment;
    data['scheduled_delivery'] = this.scheduledDelivery;
    data['todays_payment'] = this.todaysPayment;
    data['todays_delivery'] = this.todaysDelivery;
    return data;
  }
}
