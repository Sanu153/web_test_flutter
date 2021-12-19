import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/trade_buy_sell_request.dart';

class TradeRequest {
  String responseStatus;
  int totalRequestsCount;
  int buyRequestsCount;
  int sellRequestsCount;
  BuySellCount counter;
  List<TradeBuySellRequest> tradeBuySellRequest;

  TradeRequest(
      {this.counter,
      this.responseStatus,
      this.totalRequestsCount,
      this.buyRequestsCount,
      this.sellRequestsCount,
      this.tradeBuySellRequest});

  TradeRequest.fromJson(Map<String, dynamic> json) {
    responseStatus = json['response_status'];
    totalRequestsCount = json['total_requests_count'];
    buyRequestsCount = json['buy_requests_count'];
    sellRequestsCount = json['sell_requests_count'];
    this.counter = BuySellCount(
        productSpecId: null,
        buyRequestCount: buyRequestsCount,
        sellRequestCount: sellRequestsCount,
        totalRequestCount: totalRequestsCount);

    if (json['buy_requests'] != null) {
      tradeBuySellRequest = new List<TradeBuySellRequest>();
      json['buy_requests'].forEach((v) {
        tradeBuySellRequest.add(new TradeBuySellRequest.fromJson(v));
      });
    }
    if (json['sell_requests'] != null) {
      tradeBuySellRequest = new List<TradeBuySellRequest>();
      json['sell_requests'].forEach((v) {
        tradeBuySellRequest.add(new TradeBuySellRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_status'] = this.responseStatus;
    data['total_requests_count'] = this.totalRequestsCount;
    data['buy_requests_count'] = this.buyRequestsCount;
    data['sell_requests_count'] = this.sellRequestsCount;
    if (this.tradeBuySellRequest != null) {
      data['buy'] = this.tradeBuySellRequest.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
