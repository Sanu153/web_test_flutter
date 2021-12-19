import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/generalService/portfolio_service.dart';

class PortfolioAndNegotiationRepository {
  DataManager _manager;

  PortfolioAndNegotiationRepository({DataManager manager}) {
    _manager = manager;
  }

  Future<ResponseResult> getPortfolioOpenedData() =>
      PortfolioService.getProductSpecMarkets(_manager.authenticationToken,
          type: "OPENED");

  Future<ResponseResult> getPortfolioClosedData() =>
      PortfolioService.getProductSpecMarkets(_manager.authenticationToken,
          type: "CLOSED");

  Future<ResponseResult> makeNegotiation(
          Negotiation negotiation, String message, int responderId) =>
      PortfolioService.postNegotiationChat(
          _manager.authenticationToken, negotiation, message, responderId);

  Future<ResponseResult> getNegotiationList(int id) =>
      PortfolioService.getNegotiationList(_manager.authenticationToken, id);

  Future<ResponseResult> makeApproveReject(int negotiationId, String type) =>
      PortfolioService.getNegotiateApproveReject(_manager.authenticationToken,
          type: type, negotiationId: negotiationId);

  // Get Schedule
  Future<ResponseResult> getSchedule(int orderId) =>
      PortfolioService.getSchedule(_manager.authenticationToken, orderId);
}
