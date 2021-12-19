import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/supportChat/support_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/generalRepository/support_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';

class SupportBloc {
  final DataManager dataManager;
  final WebSocketRepository webSocketRepository;
  SupportChatRepository _chatRepository;

  SupportBloc({this.dataManager, this.webSocketRepository}) {
    _chatRepository = SupportChatRepository(dataManager);
  }

  final BehaviorSubject<List<SupportItem>> _supportChatSubject =
      BehaviorSubject<List<SupportItem>>();

  Observable<List<SupportItem>> get supportChat$ => _supportChatSubject.stream;

  void getChats(int id) async {
    _supportChatSubject.sink.add(supportChartData);
  }

  // Feedback Form

  Future<ResponseResult> onFeedbackSubmit(Map<String, dynamic> data) async =>
      _chatRepository.postFeedback(data);
}
