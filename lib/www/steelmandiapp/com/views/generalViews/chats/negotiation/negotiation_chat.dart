import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/approve_reject_message_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/bottom_filter_section.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/message_body_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/negoatiation_message_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/chats/negotiation/negotiation_validation_error.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyNegotiationChat extends StatefulWidget {
  final String tradeUnit;
  final Negotiation lastNegotiation;
  final UserModel responder;
  final PortfolioBloc portfolioBloc;
  final double quantityRemaining;
  final String requestUserType;

  MyNegotiationChat(
      {@required this.lastNegotiation,
      this.responder,
      this.portfolioBloc,
      this.tradeUnit = "T",
      this.requestUserType,
      this.quantityRemaining});

  @override
  _MyNegotiationChatState createState() => _MyNegotiationChatState();
}

class _MyNegotiationChatState extends State<MyNegotiationChat>
    with WidgetsBindingObserver {
  final double minValue = 8.0;
  ScrollController _scrollController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool hasAllowedPost = true;

  Future<void> _onCreated() async {
    final bool isResult = await widget.portfolioBloc
        .getNegotiations(widget.lastNegotiation.requestResponderId);
  }

  void _onApproveReject(String type, Negotiation negotiation) async {
    if (!mounted) return;
    final result = await DialogHandler.negotiationConfirmationDialog(
        context: context,
        hasApproved: type != 'Rejected',
        content: MyMessageTile(
          negotiation: negotiation,
          isCurrentUser: false,
          allowCurve: false,
          lastAllowed: false,
        ),
        onSubmit: () async {
          // Close Dialog
          Navigator.of(context).pop();

          final bool hasSuccess = await widget.portfolioBloc
              .makeNegotiationApproveReject(type, negotiation.id);

          if (hasSuccess) {
            setState(() {
              hasAllowedPost = false;
            });
          }

//          await Future.delayed(Duration(seconds: 1));
          // Close The Chat Window
//          Navigator.of(context).pop();
        });
  }

  _makeINitial() {
    widget.portfolioBloc.makeItInitial();
  }

  void _establishChannel() async {
    // Subscribe To WebSocket NegotiationChannel
    widget.portfolioBloc
        .chatNegotiation(widget.lastNegotiation.requestResponderId);
  }

  void _onProfileLongPressed() {}

  Negotiation _lastNegotiation() {
    final UserModel loggedInUser =
        Provider.of(context).dataManager.authUser.user;
    Negotiation _lastEmitNegotiation =
        widget.portfolioBloc.lastNegotiationValue();

    int _userId = 0;

    // Last Negotiation is mine Then Update My Bottom Filter Fields.
    if (_lastEmitNegotiation.proposerId == loggedInUser.userId) {
      _userId = loggedInUser.userId;
    } else {
      _userId = widget.responder.userId;
    }

    final List<NegotiationListItem> otherParty =
        widget.portfolioBloc.getNegotiationWithProposerId(_userId);
    print("Other Party Negotaition: ${otherParty}");
    final Negotiation _other = otherParty.length == 0 ? null : otherParty.first;
    if (_other == null) {
      return null;
    }
    if (_other is Negotiation) {
      return _other;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("Did Change Dependncies");
    _establishChannel();
  }

  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    _makeINitial();
    _scrollController = ScrollController(initialScrollOffset: 0);
    _onCreated();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _establishChannel();
    }
  }

  @override
  dispose() {
    //print("Chat Dismissed");
    WidgetsBinding.instance.removeObserver(this);
    widget.portfolioBloc.makeItInitial();
    _scrollController.dispose();
    widget.portfolioBloc.unSubscribeChannel();
    super.dispose();
  }

  Widget _buildAppBar() {
    final title =
        Theme.of(context).textTheme.caption.apply(color: Colors.white54);
    final sub =
        Theme.of(context).textTheme.subtitle2.apply(color: Colors.white);

    final UserModel _loggedInUser =
        Provider.of(context).dataManager.authUser.user;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: minValue * 2, color: Colors.white54),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0.0,
      title: MediaQuery.of(context).orientation == Orientation.portrait
          ? Container()
          : Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: widget.responder.imageUrl == null
                      ? AssetImage('assets/image/default_user.png')
                      : NetworkImage(widget.responder.imageUrl),
                  radius: minValue * 1.7,
                ),
                SizedBox(
                  width: minValue - 2,
                ),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "${widget.responder.name}",
                                style: sub,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 5),
                                decoration: BoxDecoration(
                                    color: widget.requestUserType == 'Buyer'
                                        ? greenColor
                                        : redColor,
                                    borderRadius:
                                        BorderRadius.circular(minValue)),
                                child: Text(
                                  "${widget.requestUserType}",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              )
                            ],
                          ),
                        ),
                        StreamBuilder<double>(
                            stream: widget
                                .portfolioBloc.portfolioQuantityRemaining$,
                            initialData: 0.0,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Container();
                              return Container(
                                padding: EdgeInsets.all(minValue),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "Quantity Remaining",
                                      style: TextStyle(
                                          color: Colors.yellow[800],
                                          fontSize: 10.0),
                                    ),
                                    Text(
                                      "${snapshot.data} ${widget.tradeUnit}",
                                      style: TextStyle(
                                          color: Colors.yellow[800],
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel currentUser =
        Provider.of(context).dataManager.authUser.user;

    return RefreshIndicator(
      onRefresh: () {
        return _onCreated();
      },
      child: SafeArea(
        top: true,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: filterBackground,
          appBar: MediaQuery.of(context).orientation == Orientation.landscape
              ? _buildAppBar()
              : null,
          body: StreamMania<Negotiation>(
              onWaiting: (context) => MyComponentsLoader(),
              onFailed: (context, Failure f) => ResponseFailure(
                    title: "No Chats Available",
                    subtitle: "Initiate a negotiation",
                  ),
              stream: widget.portfolioBloc.portfolioNegotiationChatList$,
              onSuccess: (context, List<NegotiationListItem> negoList) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
//                height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.symmetric(vertical: minValue),
                            itemCount: negoList.length,
                            itemBuilder: (context, index) {
                              final item = negoList[index];
                              if (item is NegotiationValidationError) {
                                return MyNegotiationValidationError(
                                  validationError: item,
                                );
                              } else if (item is Negotiation) {
                                //print("Item is ${item.runtimeType}");
                                final Negotiation _nego = negoList[index];
                                final bool isMe =
                                    _nego.proposerId == currentUser.userId;
                                bool onlyLastAllowed = false;

                                if (!isMe && index == 0) {
                                  onlyLastAllowed = true;
                                  // The Last Message Of The Responder SHould Allow to perform action=> Reject and Approve
                                }
//                            return Text("$index : $onlyLastAllowed");

                                return MyMessageTile(
                                  negotiation: _nego,
                                  isCurrentUser: isMe,
                                  lastAllowed: onlyLastAllowed,
                                  onAction: _onApproveReject,
                                );
                              } else if (item is NegotiationMessage) {
                                final bool _me =
                                    item.proposerId == currentUser.userId;
                                return MyMessageBody(
                                  message: "${item.textMessage}",
                                  isMe: _me,
                                );
                              } else if (item is ApproveRejectMessage) {
                                return ApproveRejectMessageTile(
                                  message: item,
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: hasAllowedPost
                          ? MyBottomFilter(
                              negotiation:
                                  _lastNegotiation() ?? widget.lastNegotiation,
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16.0),
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white70),
                              ),
                            ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
