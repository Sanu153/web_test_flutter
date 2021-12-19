import 'package:flutter/cupertino.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/productService/product_service.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/socketService/web_socket_service.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/database_helper.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/shared_preference_data.dart';

class ProductRepository {
  ProductService productService;
  DatabaseHelper productHelper;
  final DataManager dataManager;
  WebSocket _webSocket;

  ProductRepository(this.dataManager) {
    productService = ProductService();
    productHelper = DatabaseHelper();
  }

  /// *********** SERVER DATA ************///
  // Preference Products
  Future<ResponseResult> preferenceProductList(bool isAdd) =>
      productService.getPreferProductList(
          dataManager.authenticationToken, isAdd); // Preference Products
  Future<ResponseResult> getProductSpecMarkets(int id, {bool isAdd}) =>
      productService.getProductSpecMarkets(dataManager.authenticationToken, id,
          isAdd: isAdd);

  /// ****** Default Product Case ******* ************* ///
  Future<ResponseResult> getDefaultProduct() =>
      productService.getDefaultProduct(dataManager.authenticationToken);

  /// ****** ProductSpecMarket Graph ******* ************* ///
  Future<ResponseResult> getProductSpecMarketGraph(
          int specId, List<int> marketIds) =>
      productService.getProductSpecMarketGraph(dataManager.authenticationToken,
          marketsListId: marketIds, specId: specId);

  /// ****** ProductSpecMarket Graph ******* ************* ///
  Future<ResponseResult> getTimeFrameGraphData(
          int specId, List<int> marketIds, int timeFrameId) =>
      productService.getPointsOnTimeFrame(dataManager.authenticationToken,
          marketsListId: marketIds, specId: specId, timeFrameId: timeFrameId);

  /// *********** LOCAL DATA ************///

  Future<List<UserProduct>> getAllProductBarList() =>
      productHelper.getAllProduct();

  Future<int> saveProductSpecToLocal({@required UserProduct localProduct}) =>
      productHelper.insertProduct_(localProduct);

  Future<int> saveAndUpdateToLocal({@required UserProduct localProduct}) =>
      productHelper.updateProduct_(localProduct);

  Future<int> deleteAndUpdateCurrentProduct(String generatedId) =>
      productHelper.deleteCurrentProduct(generatedId);

  Future<String> getLastActiveProductId() =>
      SharedData.getLastActiveProductId();

  Future<bool> saveLastActiveProductId(String productId) =>
      SharedData.saveLastActiveProductId(productId);

//// Web SOCKET '''/////

}
