import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/sidebar_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/open_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/portfolio_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_flags.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/generalRepository/portfolio_and_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/webSocketRepository/websocket_repo.dart';

class PortfolioBloc {
  final DataManager dataManager;
  PortfolioAndNegotiationRepository _portfolioRepository;
  final WebSocketRepository webSocketRepository;
  final SideBarBloc sideBarBloc;

  PortfolioBloc(
      {this.dataManager, this.webSocketRepository, this.sideBarBloc}) {
    _portfolioRepository =
        PortfolioAndNegotiationRepository(manager: dataManager);
  }

  final BehaviorSubject<Map<Object, Object>> _userPortfolioSubject =
      BehaviorSubject<Map<Object, Object>>();

  final BehaviorSubject<int> _userPortfolioSubjectOpenCounter =
      BehaviorSubject<int>.seeded(0);

  final BehaviorSubject<int> _userPortfolioSubjectClosedCounter =
      BehaviorSubject<int>.seeded(0);

  // Number Of Unseen Request
  final BehaviorSubject<int> _userPortfolioUnseenRequestCounter =
      BehaviorSubject<int>.seeded(0);

  final BehaviorSubject<Map<Object, Object>>
      _portfolioNegotiationChatListSubject =
      BehaviorSubject<Map<Object, Object>>();

  final BehaviorSubject<double> _userPortfolioQuantityRemainingSubject =
      BehaviorSubject<double>.seeded(0.0);

  final BehaviorSubject<Map<Object, Object>> _portfolioApproveRejectSubject =
      BehaviorSubject<Map<Object, Object>>.seeded({
    ActionState: ActionState.INITIAL,
    Failure: null,
    ResponseFlags: null
  });

  Observable<Map<Object, Object>> get portfolioApproveReject$ =>
      _portfolioApproveRejectSubject.stream;

  Observable<double> get portfolioQuantityRemaining$ =>
      _userPortfolioQuantityRemainingSubject.stream;

  Observable<Map<Object, Object>> get portfolioNegotiation$ =>
      _userPortfolioSubject.stream;

  Observable<Map<Object, Object>> get portfolioNegotiationChatList$ =>
      _portfolioNegotiationChatListSubject.stream;

  Observable<int> get portfolioOpenedCounter$ =>
      _userPortfolioSubjectOpenCounter.stream;

  Observable<int> get portfolioClosedCounter$ =>
      _userPortfolioSubjectClosedCounter.stream;

  Observable<int> get portfolioUnseenRequestCounter$ =>
      _userPortfolioUnseenRequestCounter.stream;

  void dispose() {
    _userPortfolioSubject.close();
    _userPortfolioSubjectClosedCounter.close();
    _userPortfolioSubjectOpenCounter.close();
    //print("Streams Closed");
  }

  /// GETTERS******
  Negotiation lastNegotiationValue() {
    List<NegotiationListItem> _negoList = getNegotiationList;
    if (_negoList != null) {
      int length = _negoList.length;
      NegotiationListItem item = _negoList.firstWhere(
          (NegotiationListItem item) => item is Negotiation,
          orElse: null);
      return item;
//      if (_negoList[0] is Negotiation) {
//        // Get LAst Emited Negotiation Value
//        return _negoList[length - 1];
//      }
    }
    return null;
  }

  // Get Opened Requests,
  Portfolio get getPortfolio => _userPortfolioSubject.value == null
      ? null
      : _userPortfolioSubject.value[Portfolio];

  void updateRequestUnseenCounter(int number) {
//    print("Updated Portfolio UnSeen Counter To Sink: $number");
    _userPortfolioUnseenRequestCounter.sink.add(number);
  }

  void makeInitial() {
    print("Portfolio Initial State");
    _updateOpenedStream(ActionState.INITIAL, null, null);
  }

  void _updateOpenedStream(
      ActionState state, Failure failure, Portfolio portfolio) {
    final Map<Object, Object> _initialMap = {};
    _initialMap[ActionState] = state;
    _initialMap[Failure] = failure;
    _initialMap[Portfolio] = portfolio;
    _userPortfolioSubject.sink.add(_initialMap);
  }

  void _updateNegotiationChatStream(ActionState state, Failure failure,
      List<NegotiationListItem> negotiation) {
    final Map<Object, Object> _initialMap = {};
    _initialMap[ActionState] = state;
    _initialMap[Failure] = failure;
//    _initialMap[Negotiation] = negotiation;
    _initialMap[Negotiation] = negotiation;
    _portfolioNegotiationChatListSubject.sink.add(_initialMap);
  }

  void _updateNegotiationApproveReject(
      ActionState state, Failure failure, ResponseFlags flags) {
    final Map<Object, Object> _initialMap = {};
    _initialMap[ActionState] = state;
    _initialMap[Failure] = failure;
    _initialMap[ResponseFlags] = flags;
    _portfolioApproveRejectSubject.sink.add(_initialMap);
  }

  void makeItInitial() {
    _updateNegotiationChatStream(ActionState.INITIAL, null, null);
    _updateNegotiationApproveReject(ActionState.INITIAL, null, null);
  }

  void updateQuantityRemaining(double quantity) {
    _userPortfolioQuantityRemainingSubject.sink.add(quantity);
  }

  void _updateToNegotiationChatStream(NegotiationListItem negotiation) {
    List<NegotiationListItem> _negoList = getNegotiationList;
//    _negoList.add(negotiation);
    // Handle When Someone responded to you for chat, When you are on doing something else in dashboard.
    if (_negoList == null || negotiation == null) return;
    _negoList.insert(0, negotiation);
    _updateNegotiationChatStream(ActionState.SUCCESS, null, _negoList);
  }

  void _updateToNegotiationErrorChatStream(NegotiationValidationError error) {
    List<NegotiationListItem> _negoList = getNegotiationList;
//    _negoList.add(negotiation);
    _negoList.insert(0, error);
    _updateNegotiationChatStream(ActionState.SUCCESS, null, _negoList);
  }

  List<NegotiationListItem> get getNegotiationList {
    final Map<Object, Object> chatResponse =
        _portfolioNegotiationChatListSubject.value;
    if (chatResponse[Negotiation] != null) {
      return chatResponse[Negotiation];
    }
  }

  List<NegotiationListItem> getNegotiationWithProposerId(int proposerId) {
    return getNegotiationList
        .where((NegotiationListItem item) =>
            item is Negotiation && item.proposerId == proposerId)
        .toList();
  }

  NegotiationListItem get firstNegotiationStreamValue =>
      getNegotiationList.first;

  Future<void> makeNegotiation(
      Negotiation negotiation, String message, int responderId) async {
//    //print('Posting Negotiation With Data: ${}')
    try {
      // Check Whether message|| Negotiation
      double _remQua = _userPortfolioQuantityRemainingSubject.value;

      if (negotiation != null) {
        if (negotiation.quantity > _remQua) {
          //print("Validation Error");
          final error = NegotiationValidationError(remainingQuantity: _remQua);
          _updateToNegotiationErrorChatStream(error);
          return;
        }
      }

      ResponseResult _result = await _portfolioRepository.makeNegotiation(
          negotiation, message, responderId);
      if (_result.data is Failure) {
        final Failure failure = _result.data;
        final error = NegotiationValidationError(
            responseStatus: failure.responseStatus,
            responseMessage: failure.responseMessage,
            remainingQuantity: _remQua);
        _updateToNegotiationErrorChatStream(error);
      } else if (_result.data is double) {
        //print("Quantity Remaining In Portfolio Bloc: ${_result.data}");
        _userPortfolioQuantityRemainingSubject.sink.add(_result.data);

        // Either You make an api call or post Negotiation model  to current NegotiationList stream
//        getNegotiationList(negotiation.requestResponderId);

        // Handle Web Socket Data, Otherwise Data Will Be Doubled

        final int userId = dataManager.authUser.user.userId;
        //print("User Name: ${dataManager.authUser.user.name}");

        if (message != null) {
          _updateToNegotiationChatStream(
              NegotiationMessage(textMessage: message, proposerId: userId));
          return;
        }

        negotiation.proposerId = userId;
        _updateToNegotiationChatStream(negotiation);
      }
    } catch (e) {
      //print("Error In Posting Negotiation: ${e.toString()}");
    }
  }

  // Get Negotiation List For Open Deals
  Future<bool> getNegotiations(int requestResponderId) async {
    final List<NegotiationListItem> _items = List<NegotiationListItem>();

    bool status = false;
    _items.clear();
    try {
      _updateNegotiationChatStream(ActionState.LOADER, null, null);
      ResponseResult _result =
          await _portfolioRepository.getNegotiationList(requestResponderId);
      if (_result.data is Failure) {
        _updateNegotiationChatStream(ActionState.FAILED, _result.data, null);
      } else if (_result.data is Success) {
        List<NegotiationListItem> _nList = _result.data.data;
        //print("Negoatiation Data: ${_nList.runtimeType}");

        // Seggregate Message and Negotiation
        _nList.forEach((NegotiationListItem item) {
          if (item is Negotiation) {
            /// First add messages to list as it is need to display in reversed order
            final List<NegotiationMessage> _messageList =
                item.negotiationChatMessages;
            if (_messageList != null && _messageList.length > 0) {
              _messageList.forEach((NegotiationMessage message) {
                _items.add(message); // Add Message to NegotiationItem
              });
            }
            // At End Add Negotiation Model to NegotiationItem
            _items.add(item);
          }
        });
        _updateNegotiationChatStream(ActionState.SUCCESS, null, _items);
        status = true;
      }
    } catch (e) {
      //print("Errro In Getting Negotiation List: ${e.toString()}");
      _updateNegotiationChatStream(ActionState.LOADER, Failure(), null);
    }
    return status;
  }

  // Get Negotiation Chat History
  Future<ResponseResult> getChatHistoryNegotiationList(
      int requestResponderId) async {
    final List<NegotiationListItem> _items = List<NegotiationListItem>();

    _items.clear();
    ResponseResult _result =
        await _portfolioRepository.getNegotiationList(requestResponderId);

    if (_result.data is Failure) {
      _updateNegotiationChatStream(ActionState.FAILED, _result.data, null);
    } else if (_result.data is Success) {
      List<NegotiationListItem> _nList = _result.data.data;
      //print("Negoatiation Data: ${_nList.runtimeType}");

      // Seggregate Message and Negotiation
      _nList.forEach((NegotiationListItem item) {
        if (item is Negotiation) {
          /// First add messages to list as it is need to display in reversed order
          final List<NegotiationMessage> _messageList =
              item.negotiationChatMessages;
          if (_messageList != null && _messageList.length > 0) {
            _messageList.forEach((NegotiationMessage message) {
              _items.add(message); // Add Message to NegotiationItem
            });
          }
          // At End Add Negotiation Model to NegotiationItem
          _items.add(item);
        }
      });
    }
    return ResponseResult(data: Success(data: _items));
  }

//  void _testPortfolio(Portfolio portfolio) {
//    final _firstRequest = portfolio.listOfOpenNegotiations.first;
//    print(
//        "First Index: ${portfolio.listOfOpenNegotiations.indexOf(_firstRequest)}");
//    print(
//        "Last Index: ${portfolio.listOfOpenNegotiations.indexOf(portfolio.listOfOpenNegotiations[1])}");
//  }

  Future<void> getOpenedPortfolio(String type) async {
    print("Portfolio Called");
//    print("Portfolio Init: $getPortfolio");

    try {
      updateRequestUnseenCounter(0);
      ResponseResult _result;
      _updateOpenedStream(ActionState.LOADER, null, null);
      if (type == 'CLOSED') {
        //print("CLosed");
        _result = await _portfolioRepository.getPortfolioClosedData();
      } else {
        _result = await _portfolioRepository.getPortfolioOpenedData();
      }

      //print(_result.data is Failure);
      if (_result.data is Failure) {
        _updateOpenedStream(ActionState.FAILED, _result.data, null);
      } else if (_result.data is Portfolio) {
        Portfolio _portfolio = _result.data;
        int _openedCount = _portfolio.openNegotiationsCount ?? 0;
        int _closedCount = _portfolio.closedNegotiationsCount ?? 0;
        // Display Msg When No Count==0

        _userPortfolioSubjectOpenCounter.sink.add(_openedCount);
        _userPortfolioSubjectClosedCounter.sink.add(_closedCount);
        if (_openedCount == 0) {
          if (type == 'OPENED') {
            _updateOpenedStream(
                ActionState.FAILED,
                Failure(
                    responseStatus: "Not Available",
                    responseMessage: "No Requests Available"),
                null);
            return;
          }
        }
        if (_closedCount == 0) {
          if (type == 'CLOSED') {
            _updateOpenedStream(
                ActionState.FAILED,
                Failure(
                    responseStatus: "Not Available",
                    responseMessage: "No Requests Available"),
                null);
            return;
          }
        }
        _updateOpenedStream(ActionState.SUCCESS, null, _portfolio);
      }
    } catch (e) {
      //print(e);
      _updateOpenedStream(ActionState.LOADER, Failure(), null);
    }
  }

  Future<bool> makeNegotiationApproveReject(String type, int negoId) async {
    bool hasSuccess = false;
    try {
      _updateNegotiationApproveReject(ActionState.LOADER, null, null);
      ResponseResult _result =
          await _portfolioRepository.makeApproveReject(negoId, type);
      print("Action Type: $type");
      if (_result.data is Failure) {
        print("Failed");
        hasSuccess = false;
        _updateNegotiationApproveReject(ActionState.FAILED, _result.data, null);
      } else if (_result.data is ResponseFlags) {
        _updateNegotiationApproveReject(
            ActionState.SUCCESS, null, _result.data);

        // Add Success Message To The List Item
        final ApproveRejectMessage _msg = ApproveRejectMessage(
            message: _result.data.responseMessage ??
                'Your request has been ${type == 'Rejected' ? 'rejected' : 'approved'} .',
            negotiationAction: type == 'Rejected'
                ? NegotiationAction.REJECT
                : NegotiationAction.APPROVE);

        // Add To The Stream

        getNegotiationList.insert(0, _msg);
        _updateNegotiationChatStream(
            ActionState.SUCCESS, null, getNegotiationList);

        hasSuccess = true;

        // On Success Approved Or Reject
        // Refresh Portfolio API
        getOpenedPortfolio("OPENED");
      }
    } catch (e) {
      //print("Error Occored In Approve Reject: $e");
      _updateNegotiationApproveReject(ActionState.ERROR, null, null);
    }
    return hasSuccess;
  }

  // Get Schedule

  Future<ResponseResult> getSchedule(int orderId) =>
      _portfolioRepository.getSchedule(orderId);

  ///*******// Web Socket Stuff
  ///

  void portFolioOpenClosedSocket() {
    _portfolioOpenSocket();
    _portfolioClosedSocket();
  }

  void _portfolioOpenSocket() {
    webSocketRepository.portfolioOpenRequestSocket(onSubscribed: () {
      print("Subscribe to Portfolio Open Channel");
    }, onData: (OpenNegotiation latestRequest) {
      if (getPortfolio != null) {
        // When User Is On Portfolio Section and Negotiation Is Going On
        final List<OpenNegotiation> _openRequests =
            getPortfolio.listOfOpenNegotiations;
//        print("_openRequests: $_openRequests");
        if (_openRequests == null) {
          // When User Is In Closed Tab=> User receives Portfolio Broadcast=> Update Only Green Dot

          // Activate Green Dot
          int _unseen = _userPortfolioUnseenRequestCounter.value;
          updateRequestUnseenCounter(_unseen + 1);
          return;
        }
        if (_openRequests.length == 0) {
          // No Request Available
          // Add First Request
          getPortfolio.listOfOpenNegotiations.add(latestRequest);
        } else {
          final _findRequest = _openRequests.firstWhere(
              (element) => element.id == latestRequest.id,
              orElse: null);
          if (_findRequest != null) {
            // Request is In List
            // Find the index
//            int _requestIndex = _openRequests.indexOf(_findRequest);
            final _isRemoved = _openRequests.remove(_findRequest);
          } else {
            // Update Open Counter => If Request is not in List
            _userPortfolioSubjectOpenCounter.sink
                .add(getPortfolio.listOfOpenNegotiations.length + 1);
          }
          getPortfolio.listOfOpenNegotiations = _openRequests;
          getPortfolio.listOfOpenNegotiations.insert(0, latestRequest);
        }

        // Activate Green Dot
        int _unseen = _userPortfolioUnseenRequestCounter.value;
        updateRequestUnseenCounter(_unseen + 1);

        // Update List
        _updateOpenedStream(ActionState.SUCCESS, null, getPortfolio);
      } else {
        // When User doesn't open portfolio window and someone responds to the request
        // Show Only Portfolio Green Dot or Counter
        int _unseen = _userPortfolioUnseenRequestCounter.value;
        print("Unseen Counter: $_unseen");
        updateRequestUnseenCounter(_unseen + 1);
      }
    });
  }

  void _portfolioClosedSocket() {
    webSocketRepository.portfolioClosedRequestSocket(onSubscribed: () {
      print("Subscribe to Portfolio Closed Channel");
    }, onData: (OpenNegotiation latestRequest) {
      // Update Portfolio GreenDot Stream
      print(
          "Latest Closed Request Quantity: ${latestRequest.quantityRemaining}");

      if (getPortfolio != null) {
        final List<OpenNegotiation> _closedRequests =
            getPortfolio.listOfCLosedNegotiations;
        print("_closedRequests: $_closedRequests");

        if (_closedRequests == null) {
          // Receiver User Is On Open Tab => Only Update Open Counter
          _userPortfolioSubjectClosedCounter.sink
              .add(_userPortfolioSubjectClosedCounter.value + 1);

          int _unseen = _userPortfolioUnseenRequestCounter.value;
          updateRequestUnseenCounter(_unseen + 1);
          return;
        }

        if (_closedRequests.length == 0) {
          // No Request Available
          // Add First Request
          getPortfolio.listOfCLosedNegotiations.add(latestRequest);
        } else {
          getPortfolio.listOfCLosedNegotiations = _closedRequests;
          getPortfolio.listOfCLosedNegotiations.insert(0, latestRequest);

//          int _unseen = _userPortfolioUnseenRequestCounter.value;
//          updateRequestUnseenCounter(_unseen + 1);
        }
//
        //Update Opened Stream

        _userPortfolioSubjectClosedCounter.sink
            .add(getPortfolio.listOfCLosedNegotiations.length + 1);

        int _unseen = _userPortfolioUnseenRequestCounter.value;
        updateRequestUnseenCounter(_unseen + 1);

        _updateOpenedStream(ActionState.SUCCESS, null, getPortfolio);
      } else {
        // When User doesn't open portfolio window and someone responds to the request
        // Show Only Portfolio Green Dot or Counter
        int _unseen = _userPortfolioUnseenRequestCounter.value;

        updateRequestUnseenCounter(_unseen + 1);
      }
    });
  }

  void unSubscribeChannel() {
    //print("Unsubscribed");
//    webSocketRepository.unSubscribeChatNegotiation();
  }

  void chatNegotiation(int requestResponderId) {
    //print("Negoatiation: Id: $requestResponderId");

    webSocketRepository.negotiationChannel(requestResponderId,
        onSubscribed: () {
      //print("Subscribed To Negotiation channel with Id: $requestResponderId");
    }, onData: (NegotiationListItem data) {
      // Don't Update Negotiation or Message On Sender's UI Through Web Socket
      // It is being updated through REST API Response
      if (data is NegotiationMessage) {
        if (data.proposerId == dataManager.authUser.user.userId) return;
      } else if (data is Negotiation) {
        if (data.proposerId == dataManager.authUser.user.userId) return;
      } else if (data is ApproveRejectMessage) {
        if (data.user.userId == dataManager.authUser.user.userId) return;

        // Update Receiver UI
        getOpenedPortfolio('OPEN');
      }

      //print("I am not Sender. So My UI Is Updated");
      _updateToNegotiationChatStream(data);
    });
  }
}
