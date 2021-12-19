import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/adherence.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/contract.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/schedule.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_unit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class Order {
  int id;
  String productSpecName;
  String dispName;
  String productName;
  String dispIcon;
  UserModel buyer;
  UserModel seller;
  double pricePerUnit;
  int paymentsInDays;
  int deliveryInDays;
  int tradeUnitId;
  double quantity;
  String status;
  Contract contract;
  List<Schedule> schedule;
  List<Adherence> adherence;
  bool isScheduleApproved;

  TradeUnit tradeUnit;
  String marketName;

  Order(
      {this.id,
      this.productSpecName,
      this.dispName,
      this.dispIcon,
      this.buyer,
      this.seller,
      this.pricePerUnit,
      this.paymentsInDays,
      this.deliveryInDays,
      this.tradeUnitId,
      this.quantity,
      this.status,
      this.contract,
      this.schedule,
      this.adherence,
      this.tradeUnit,
      this.marketName,
      this.productName,
      this.isScheduleApproved});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['order_id'];
    productSpecName = json['product_spec_name'];
    dispName = json['disp_name'];
    dispIcon = json['disp_icon'];
    productName = json['product_name'];

    pricePerUnit = json['price_per_unit'];
    paymentsInDays = json['payments_in_days'];
    deliveryInDays = json['delivery_in_days'];
    tradeUnitId = json['trade_unit_id'];
    quantity = json['quantity'];
    status = json['status'];
    isScheduleApproved = json['is_schedule_approved'];
    if (json['contract'] != null) {
      contract = new Contract.fromJson(json['contract']);
    }
    if (json['schedule'] != null) {
      schedule = new List<Schedule>();
      json['schedule'].forEach((v) {
        schedule.add(new Schedule.fromJson(v));
      });
    }
    if (json['adherence'] != null) {
      adherence = new List<Adherence>();
      json['adherence'].forEach((v) {
        adherence.add(new Adherence.fromJson(v));
      });
    }
//    print(json['buyer']);
    if (json['buyer'] != null) {
      buyer = UserModel.fromJson(json['buyer']);
    }

    if (json['seller'] != null) {
      seller = UserModel.fromJson(json['seller']);
    }

    this.tradeUnit = json['trade_unit'] != null
        ? TradeUnit.fromJson(json['trade_unit'])
        : null;

    this.marketName = json['market_name'];
  }
}
