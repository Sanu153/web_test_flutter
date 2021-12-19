import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/services/generalService/support_chat.dart';

class SupportChatRepository {
  SupportChatService supportChatService;
  final DataManager dataManager;

  // String announcementType = '';

  SupportChatRepository(this.dataManager) {
    supportChatService = SupportChatService();
  }

  Future<ResponseResult> postFeedback(Map<String, dynamic> data) =>
      supportChatService.postFeedback(dataManager.authenticationToken, data);
}
