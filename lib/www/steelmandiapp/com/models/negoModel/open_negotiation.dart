import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_hierarchy.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/portfolio_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/responder_negotistion.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_unit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class OpenNegotiation {
  int id;
  int userId;
  int productSpecId;
  String buySell;
  double pricePerUnit;
  String customRequirements;
  String createdAt;
  String updatedAt;
  String status;
  int marketHierarchyId;
  String place;
  String validUpto;
  int tradeUnitId;
  double quantity;
  UserModel user;
  ProductSpec productSpec;
  MarketHierarchy marketHierarchy;
  TradeUnit tradeUnit;
  List<RespondersAndNegotiations> respondersAndNegotiations;
  double quantityRemaining;

  OpenNegotiation(
      {this.id,
      this.userId,
      this.productSpecId,
      this.buySell,
      this.pricePerUnit,
      this.customRequirements,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.marketHierarchyId,
      this.place,
      this.validUpto,
      this.tradeUnitId,
      this.quantity,
      this.user,
      this.productSpec,
      this.marketHierarchy,
      this.tradeUnit,
      this.respondersAndNegotiations,
      this.quantityRemaining});

  OpenNegotiation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productSpecId = json['product_spec_id'];
    buySell = json['buy_sell'];
    pricePerUnit = json['price_per_unit'];
    customRequirements = json['custom_requirements'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    marketHierarchyId = json['market_hierarchy_id'];
    place = json['place'];
    validUpto = json['valid_upto'];
    tradeUnitId = json['trade_unit_id'];
    quantity = json['quantity'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    productSpec = json['product_spec'] != null
        ? new ProductSpec.fromJson(json['product_spec'])
        : null;
    marketHierarchy = json['market_hierarchy'] != null
        ? new MarketHierarchy.fromJson(json['market_hierarchy'])
        : null;
    tradeUnit = json['trade_unit'] != null
        ? new TradeUnit.fromJson(json['trade_unit'])
        : null;
    if (json['responders_and_negotiations'] != null) {
      respondersAndNegotiations = new List<RespondersAndNegotiations>();
      json['responders_and_negotiations'].forEach((v) {
        respondersAndNegotiations
            .add(new RespondersAndNegotiations.fromJson(v));
      });
    }
    quantityRemaining = json['quantity_remaining'];
  }
}
