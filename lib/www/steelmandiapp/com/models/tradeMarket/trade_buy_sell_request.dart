import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_hierarchy.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_unit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

abstract class ListItem {}

class HeadingItem implements ListItem {
  final String time;

  HeadingItem(this.time);
}

class TradeBuySellRequest implements ListItem {
  int id;
  int userId;
  int productSpecId;
  String buySell;
  double quantity;
  double quantityRemaining;
  double price;
  String customRequirements;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  int marketHierarchyId;
  String place;
  DateTime validUpto;
  MarketHierarchy marketHierarchy;
  bool thisTraderHasResponded;
  TradeUnit tradeUnit;
  ProductSpec productSpec;
  UserModel user;

  TradeBuySellRequest(
      {this.id,
      this.userId,
      this.productSpecId,
      this.buySell,
      this.quantity,
      this.price,
      this.customRequirements,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.marketHierarchyId,
      this.place,
      this.validUpto,
      this.thisTraderHasResponded,
      this.tradeUnit,
      this.productSpec,
      this.user,
      this.marketHierarchy,
      this.quantityRemaining});

  TradeBuySellRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productSpecId = json['product_spec_id'];
    buySell = json['buy_sell'];
    quantity = json['quantity'] != null
        ? json['quantity'] is double
            ? json['quantity']
            : json['quantity'].toDouble()
        : 0.0;
    quantityRemaining = json['quantity_remaining'] != null
        ? json['quantity_remaining'] is double
            ? json['quantity_remaining']
            : json['quantity_remaining'].toDouble()
        : 0.0;
    price = json['price_per_unit'] != null
        ? json['price_per_unit'] is double
            ? json['price_per_unit']
            : json['price_per_unit'].toDouble()
        : 0.0;
    customRequirements = json['custom_requirements'];
    createdAt = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now();
    updatedAt = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : DateTime.now();
    status = json['status'];
    marketHierarchyId = json['market_hierarchy_id'];
    place = json['place'];
    validUpto = json['valid_upto'] != null
        ? DateTime.parse(json['valid_upto'])
        : DateTime.now();
    marketHierarchy = json['market_hierarchy'] != null
        ? new MarketHierarchy.fromJson(json['market_hierarchy'])
        : null;
    // After Response Modify by BackEnd
    this.user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    this.tradeUnit = json['trade_unit'] != null
        ? TradeUnit.fromJson(json['trade_unit'])
        : null;
    this.productSpec = json['product_spec'] != null
        ? ProductSpec.fromJson(json['product_spec'])
        : null;
    this.thisTraderHasResponded = json['this_trader_has_responded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_spec_id'] = this.productSpecId;
    data['buy_sell'] = this.buySell;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['custom_requirements'] = this.customRequirements;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['market_hierarchy_id'] = this.marketHierarchyId;
    data['place'] = this.place;
    data['valid_upto'] = this.validUpto;
    data['quantity_remaining'] = this.quantityRemaining;
    if (this.marketHierarchy != null) {
      data['market_hierarchy'] = this.marketHierarchy.toJson();
    }
    return data;
  }
}
