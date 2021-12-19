import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/order_detail.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class RespondersAndNegotiations {
  UserModel responder;
  Negotiation lastNegotiation;
  OrderDetail orderDetail;

  RespondersAndNegotiations(
      {this.responder, this.lastNegotiation, this.orderDetail});

  RespondersAndNegotiations.fromJson(Map<String, dynamic> json) {
    responder = json['responder'] != null
        ? new UserModel.fromJson(json['responder'])
        : null;
    lastNegotiation = json['last_negotiation'] != null
        ? new Negotiation.fromJson(json['last_negotiation'])
        : null;
    orderDetail = json['order_detail'] != null
        ? new OrderDetail.fromJson(json['order_detail'])
        : null;
  }
}
