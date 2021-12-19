import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/tradeMarket/request_responder.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/message_body_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/negoatiation_message_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/negotiation_validation_error.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class ChatHistoryScreen extends StatefulWidget {
  final RequestResponder requestResponder;
  final PortfolioBloc portfolioBloc;

  ChatHistoryScreen(
      {@required this.requestResponder, @required this.portfolioBloc});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  Future<ResponseResult> _futureResult;

  final double minValue = 8.0;

  ScrollController _scrollController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onCreated() async {
    _futureResult = widget.portfolioBloc
        .getChatHistoryNegotiationList(widget.requestResponder.id);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0);
    _onCreated();
  }

  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onDetailsClick() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _buildDetailRequest();
      },
    );
  }

  Widget _buildDetailRequest() {
    final RequestResponder _responder = widget.requestResponder;

    final title = Theme.of(context).textTheme.headline6;
    final sub = Theme.of(context).textTheme.subtitle1;
    final header = TextStyle(
        color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: minValue * 3, horizontal: minValue * 2),
      child: ListView(
        children: <Widget>[
          Text(
            "Product Information",
            style: header,
          ),
          SizedBox(
            height: minValue,
          ),
          Text(
            "Product Spec: ${_responder.productSpec}",
            style: sub,
          ),
          Text(
            "Product Category: ${_responder.productType}",
            style: sub,
          ),
          Text(
            "Market Name: ${_responder.market}",
            style: sub,
          ),
          SizedBox(
            height: minValue,
          ),
          Divider(),
          Text(
            "Responder Information",
            style: header,
          ),
          SizedBox(
            height: minValue,
          ),
          Text(
            "Name: ${_responder.partyName}",
            style: sub,
          ),
          Text(
            "Request Type: ${_responder.partyType}",
            style: sub,
          ),
          SizedBox(
            height: minValue,
          ),
          Divider(),
          Text(
            "Order Information",
            style: header,
          ),
          SizedBox(
            height: minValue,
          ),
          Text(
            "Price: ${_responder.pricePerUnit}",
            style: sub,
          ),
          Text(
            "Payment in days: ${_responder.paymentsInDays}",
            style: sub,
          ),
          Text(
            "Delivery in days: ${_responder.deliveryInDays}",
            style: sub,
          ),
          Text(
            "Quantity: ${_responder.quantity}",
            style: sub,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel currentUser =
        Provider.of(context).dataManager.authUser.user;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("${widget.requestResponder.partyName}"),
        actions: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    color: widget.requestResponder.partyType == "Buyer"
                        ? greenColor
                        : redColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "${widget.requestResponder.partyType}",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: FutureObserver(
          future: _futureResult,
          onWaiting: (context) => MyComponentsLoader(),
          onError: (context, Failure f) => ResponseFailure(
            title: f.responseMessage,
          ),
          onSuccess: (context, List<NegotiationListItem> negoList) {
            return ListView.builder(
                controller: _scrollController,
                reverse: true,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(
                    vertical: minValue * 2, horizontal: minValue),
                itemCount: negoList.length,
                itemBuilder: (context, index) {
                  final item = negoList[index];
                  print(item);
                  if (item is NegotiationValidationError) {
                    return MyNegotiationValidationError(
                      validationError: item,
                    );
                  } else if (item is Negotiation) {
                    //print("Item is ${item.runtimeType}");
                    final Negotiation _nego = negoList[index];
                    final bool isMe = _nego.proposerId == currentUser.userId;

                    return MyMessageTile(
                      negotiation: _nego,
                      isCurrentUser: isMe,
                      lastAllowed: false,
                    );
                  } else if (item is NegotiationMessage) {
                    final bool _me = item.proposerId == currentUser.userId;
                    return MyMessageBody(
                      message: "${item.textMessage}",
                      isMe: _me,
                    );
                  } else {
                    return Container();
                  }
                });
          },
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70.0,
        child: FloatingActionButton(
          backgroundColor: redColor,
//          elevation: 0.0,
          onPressed: () => onDetailsClick(),
          child: Text(
            "Show Details",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
