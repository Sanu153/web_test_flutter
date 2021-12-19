import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/generalService/announcementService.dart';
//Repository class decides which way data will be retreived through service class i.e from server or from mobile database
//we need to call service class from repository class.
//we instantiate service class here

class AnnouncementRepository {
  AnnouncementService announcementService;
  final DataManager dataManager;
  // String announcementType = '';

  AnnouncementRepository(this.dataManager) {
    announcementService = AnnouncementService();
  }

  Future<ResponseResult> newsList() {
    // announcementType = "News";
    return announcementService
        .getAnnouncementNewsList(dataManager.authenticationToken);
  }

  Future<ResponseResult> tendersList() {
    // announcementType = "Tenders";
    return announcementService
        .getAnnouncementTenderList(dataManager.authenticationToken);
  }

  Future<ResponseResult> eventsList() {
    // announcementType = "Events";
    return announcementService
        .getAnnouncementEventList(dataManager.authenticationToken);
  }

  Future<ResponseResult> postLike(int newsId) {
    // announcementType = "Events";
    return announcementService.postLike(dataManager.authenticationToken,
        id: newsId);
  }

  Future<ResponseResult> postView({int id, String type}) {
    // announcementType = "Events";
    return announcementService.postView(dataManager.authenticationToken,
        id: id, type: type);
  }
}
