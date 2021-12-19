import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/generalRepository/announcement.dart';

class AnnouncementBloc {
  final DataManager dataManager;
  AnnouncementRepository _announcementRepo;

  AnnouncementBloc({this.dataManager}) {
    _announcementRepo = AnnouncementRepository(dataManager);
  }

  //get news list

  Future<ResponseResult> getNewsList() async {
    final ResponseResult _responseResult = await _announcementRepo.newsList();
    return _responseResult;
  }

  Future<ResponseResult> getTendersList() async {
    final ResponseResult _responseResult =
        await _announcementRepo.tendersList();
    return _responseResult;
  }

  Future<ResponseResult> getEventsList() async {
    final ResponseResult _responseResult = await _announcementRepo.eventsList();
    return _responseResult;
  }

  Future<ResponseResult> postLike(int newsId) async =>
      await _announcementRepo.postLike(newsId);

  Future<ResponseResult> postView(int id, String type) async =>
      await _announcementRepo.postView(type: type, id: id);
}
