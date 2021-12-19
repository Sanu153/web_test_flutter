import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class TradeBookSchedule {
  String responseStatus;
  UserModel currentUser;
  List<CurrentSchedule> currentSchedule;

  TradeBookSchedule(
      {this.responseStatus, this.currentUser, this.currentSchedule});

  TradeBookSchedule.fromJson(Map<String, dynamic> json) {
    responseStatus = json['response_status'];
    currentUser = json['current_user'] != null
        ? new UserModel.fromJson(json['current_user'])
        : null;
    if (json['get_order'] != null) {
      currentSchedule = new List<CurrentSchedule>();
      json['get_order'].forEach((v) {
        currentSchedule.add(new CurrentSchedule.fromJson(v));
      });
    }
  }
}

class CurrentSchedule {
  int orderId;
  String productName;
  String productSpecName;
  String dispName;
  String date;
  double paymentDeliveryTillDate;
  double paymentDeliveryPendingTillDate;
  double paymentDeliveryPercentageTillDate;
  String partyName;
  String partyType;
  String action;
  int contractId;

  CurrentSchedule(
      {this.orderId,
      this.productName,
      this.productSpecName,
      this.dispName,
      this.date,
      this.paymentDeliveryTillDate,
      this.paymentDeliveryPendingTillDate,
      this.paymentDeliveryPercentageTillDate,
      this.partyName,
      this.partyType,
      this.contractId,
      this.action});

  CurrentSchedule.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productName = json['product_name'];
    productSpecName = json['product_spec_name'];
    dispName = json['disp_name'];
    date = json['date'];
    paymentDeliveryTillDate = json['payment_delivery_till_date'];
    paymentDeliveryPendingTillDate = json['payment_delivery_pending_till_date'];
    paymentDeliveryPercentageTillDate =
        json['payment_delivery_percentage_till_date'];
    partyName = json['party_name'];
    partyType = json['party_type'];
    action = json['action'];
    contractId = json['contract_id'];
  }
}
