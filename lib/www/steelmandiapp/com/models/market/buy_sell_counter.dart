class BuySellCount {
  int productId;
  int productSpecId;
  int totalRequestCount;
  int buyRequestCount;
  int sellRequestCount;

  BuySellCount(
      {this.productId,
      this.productSpecId,
        this.totalRequestCount = 0,
        this.buyRequestCount = 0,
        this.sellRequestCount = 0});

//  BuySellCount.fromJson(Map<String, dynamic> json) {
//    productId = json['product_id'];
//    productSpecId = json['product_spec_id'];
//    totalRequestsCount = json['total_requests_count'];
//    buyRequestsCount = json['buy_requests_count'];
//    sellRequestsCount = json['sell_requests_count'];
//  }

}
