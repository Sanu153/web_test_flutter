import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_hierarchy.dart';

class LastTrade {
  List<LastTradedPrices> lastTradedPrices;

  LastTrade({this.lastTradedPrices});

  LastTrade.fromJson(Map<String, dynamic> json) {
    if (json['last_traded_prices'] != null) {
      lastTradedPrices = new List<LastTradedPrices>();
      json['last_traded_prices'].forEach((v) {
        lastTradedPrices.add(new LastTradedPrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastTradedPrices != null) {
      data['last_traded_prices'] =
          this.lastTradedPrices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastTradedPrices {
  int id;
  GraphData lastTradedPrice;
  MarketHierarchy marketHierarchy;

  LastTradedPrices({this.id, this.lastTradedPrice, this.marketHierarchy});

  LastTradedPrices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastTradedPrice = json['last_traded_price'] != null
        ? new GraphData.fromJson(json['last_traded_price'])
        : null;
    marketHierarchy = json['market_hierarchy'] != null
        ? new MarketHierarchy.fromJson(json['market_hierarchy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.lastTradedPrice != null) {
      data['last_traded_price'] = this.lastTradedPrice.toJson();
    }
    if (this.marketHierarchy != null) {
      data['market_hierarchy'] = this.marketHierarchy.toJson();
    }
    return data;
  }
}
