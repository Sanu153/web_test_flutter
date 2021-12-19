import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/product_spec_market_grapph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_grouping.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_hierarchy.dart';

class ProductSpecMarket implements MarketGrouping {
  int id;
  int productSpecId;
  int marketHierarchyId;
  String currency;
  double minPrice;
  double maxPrice;
  String groupingName;
  String description;
  MarketHierarchy marketHierarchy;
  List<GraphData> graphData;
  BuySellCount counter;
  bool isSubscribedByTrader;

  ProductSpecMarket(
      {this.counter,
      this.isSubscribedByTrader,
      this.id,
      this.productSpecId,
      this.marketHierarchyId,
      this.currency,
      this.minPrice,
      this.maxPrice,
      this.groupingName,
      this.marketHierarchy,
      this.description,
      this.graphData});

  ProductSpecMarket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSpecId = json['product_spec_id'];
    marketHierarchyId = json['market_hierarchy_id'];
    currency = json['currency'];
    description = json['description'];
    final min = json['min_price'] == null ? 0 : json['min_price'];
    final max = json['max_price'] == null ? 0 : json['max_price'];
    minPrice = min is int ? min.toDouble() : min;
    maxPrice = max is int ? min.toDouble() : max;
    groupingName = json['grouping_name'];
    isSubscribedByTrader = json['is_subscribed_by_trader'];
    marketHierarchy = json['market_hierarchy'] != null
        ? new MarketHierarchy.fromJson(json['market_hierarchy'])
        : null;
    final List gd = json['graph_data'];
    if (gd != null && gd.length != 0) {
      graphData = List<GraphData>();
      json['graph_data'].forEach((v) {
        graphData.add(GraphData.fromJson(v));
      });
    }
    if (json['buy_count'] != null && json['sell_count'] != null) {
      this.counter = BuySellCount(
          productSpecId: productSpecId,
          totalRequestCount: 0,
          sellRequestCount: json['sell_count'],
          buyRequestCount: json['buy_count']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_spec_id'] = this.productSpecId;
    data['market_hierarchy_id'] = this.marketHierarchyId;
    data['currency'] = this.currency;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['grouping_name'] = this.groupingName;
    if (this.marketHierarchy != null) {
      data['market_hierarchy'] = this.marketHierarchy.toJson();
    }
    if (this.graphData != null) {
      data['graph_data'] = this.graphData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
