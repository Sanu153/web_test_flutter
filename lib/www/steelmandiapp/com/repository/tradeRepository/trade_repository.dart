import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/tradeMarketService/trade_service.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/helper/database_helper.dart';

class TradeRepository {
  TradeService _tradeService;
  DatabaseHelper _tradeHelper;
  DataManager _dataManager;

  TradeRepository(DataManager dataManager) {
    _dataManager = dataManager;
    _tradeService = TradeService();
    _tradeHelper = DatabaseHelper();
  }

  Future<ResponseResult> setAlert(
          {int marketId, String validity, double price, int productSpecId}) =>
      _tradeService.setAlert(_dataManager.authenticationToken,
          marketId: marketId,
          validity: validity,
          price: price,
          productSpecId: productSpecId);

  Future<ResponseResult> onBuySellRequestSubmit(Map<String, dynamic> dataSet) =>
      _tradeService.onBuySellRequestSubmit(
          _dataManager.authenticationToken, dataSet);

  Future<ResponseResult> getTradeBuySellRequest(
          int id, bool isBuy, marketIdList) =>
      _tradeService.getTradeBuySellRequest(
          _dataManager.authenticationToken, id, marketIdList,
          isBuy: isBuy);

  Future<ResponseResult> getTradeBuySellRespond(RespondNegotiation data) =>
      _tradeService.buySellTradeRespond(_dataManager.authenticationToken, data);

  Future<ResponseResult> getProductAndMarketInfo(
          {int specId, List<int> marketIds}) =>
      _tradeService.getProductAndMarketInfo(_dataManager.authenticationToken,
          specId: specId, marketIds: marketIds);

  // Market Subscription
  Future<ResponseResult> marketSubscription(
          {int specMarketId, bool isSubscribe}) =>
      _tradeService.marketSubscription(_dataManager.authenticationToken,
          specId: specMarketId, subscribed: isSubscribe);

  // Get Trade Contracts
  Future<ResponseResult> getTradeContracts() =>
      _tradeService.getTradeContract(_dataManager.authenticationToken);

  // Get Trade Book Schedule
  Future<ResponseResult> getTradeBookSchedule() =>
      _tradeService.getTradeBookSchedule(_dataManager.authenticationToken);

  // Get Trade Request responders List
  Future<ResponseResult> getTradeRequestResponders() =>
      _tradeService.getTradeRequestResponders(_dataManager.authenticationToken);

  // POST Adherence
  Future<ResponseResult> postAdherence(Map<String, dynamic> data) =>
      _tradeService.postAdherence(_dataManager.authenticationToken, data: data);

  // POST Adherence
  Future<ResponseResult> getAdherence(int orderId) => _tradeService
      .getAdherence(_dataManager.authenticationToken, orderId: orderId);

  // Update Schedule
  Future<ResponseResult> updateSchedule(Map<String, dynamic> data) =>
      _tradeService.updateSchedule(_dataManager.authenticationToken,
          data: data);
}
