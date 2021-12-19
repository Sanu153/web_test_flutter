import 'dart:convert';

import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/table_columns.dart';

mixin CurrentUserProduct {}

class UserProduct {
  String generatedId;
  int productId;
  String productSpecName;
  String productSpecDisplayName;
  String productSpecIcon;
  int productSpecId;

  /// {121: [OMC Gandhamardhan, 245]} => 121: ProductSpecMarketId, [Market Name, marketId]
  Map<int, List> productSpecMarketList;
  bool hasSelected;
  BuySellCount counter;
  Map<int, String> productSpecMarketMap;

  BuySellCount get counterG => counter;

//  UserGraph userGraph;

  set counterG(BuySellCount count) {
    counter = count;
  }

  UserProduct({this.productSpecMarketMap,
    this.generatedId,
    this.productSpecId,
    this.productId,
    this.productSpecDisplayName,
    this.productSpecIcon,
    this.productSpecMarketList,
    this.productSpecName,
    this.counter,
    this.hasSelected});

  UserProduct.fromLocal(Map<String, dynamic> data) {
    Map<int, List> _marketList = Map<int, List>();
    this.productId = data[ProductBarTableHelper.productIdCol];
    this.generatedId = data[ProductBarTableHelper.productSpecGeneratedIdCol];
    this.productSpecId = data[ProductBarTableHelper.productSpecIdCol];
    int select = data[ProductBarTableHelper.productSpecSelectedCol];
    this.hasSelected = select == 1 ? true : false;
    this.productSpecName = data[ProductBarTableHelper.productSpecNameCol];

    String marketS = data[ProductBarTableHelper.productSpecMarketCol];
    final marketSpecData = json.decode(marketS);
    //print("MArket data: $marketSpecData");
    marketSpecData.forEach((id, value) {
      _marketList[int.parse(id)] = value;
    });
    this.productSpecMarketList = _marketList;

//    this.productSpecMarketList = _marketList;
    this.productSpecDisplayName =
    data[ProductBarTableHelper.productSpecDisplayNameCol];
    this.productSpecIcon = data[ProductBarTableHelper.productSpecIconCol];
    // Default Counter initialize to Zero => To Prevent Null Exception
    this.counter = BuySellCount(
        buyRequestCount: 0,
        sellRequestCount: 0,
        totalRequestCount: 0,
        productSpecId: this.productSpecId,
        productId: this.productId);
  }

  Map<String, dynamic> toLocalData() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data[ProductBarTableHelper.productIdCol] = this.productId;
    data[ProductBarTableHelper.productSpecGeneratedIdCol] = this.generatedId;
    data[ProductBarTableHelper.productSpecNameCol] = this.productSpecName;
    data[ProductBarTableHelper.productSpecDisplayNameCol] =
        this.productSpecDisplayName;
    data[ProductBarTableHelper.productSpecIconCol] = this.productSpecIcon;
    data[ProductBarTableHelper.productSpecIdCol] = this.productSpecId;
    if (this.productSpecMarketList != null) {
      //print("ProductSpec List In CustomModel: $productSpecMarketList");

      // Making JsonFormat
      final Map<String, dynamic> _data = {};
      productSpecMarketList.forEach((key, value) {
        _data[key.toString()] = value;
      });
      data[ProductBarTableHelper.productSpecMarketCol] =
          json.encode(_data).toString();
      data[ProductBarTableHelper.productSpecSelectedCol] =
      this.hasSelected ? 1 : 0;
    }
    return data;
  }
}
