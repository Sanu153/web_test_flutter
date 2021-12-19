import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/support_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/feature_implement_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/supportChat/support_chat.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class MyChatScreen extends StatefulWidget {
  final User user;

  final SupportBloc bloc;

  MyChatScreen({@required this.user, this.bloc});

  @override
  _MyChatScreenState createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  final double minValue = 8.0;
  FocusNode _focusNode;
  TextEditingController _txtController = TextEditingController();

  bool isCurrentUserTyping = false;
  final double iconSize = 28.0;
  ScrollController _scrollController;

  String message = '';

  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  void _onCreated() async {
    widget.bloc.getChats(5);
  }

  initState() {
    super.initState();

    _onCreated();
    _scrollController = ScrollController(initialScrollOffset: 0);

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      //print('Something happened');
    });
    _handleRotation();
  }

  void _handleRotation() async {
    SystemConfig.makeStatusBarVisible();
    await SystemConfig.makeDevicePotrait();
  }

  @override
  void didUpdateWidget(MyChatScreen oldWidget) {
    _handleRotation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _handleRotation();
    super.didChangeDependencies();
  }

  Future<bool> _onBackTap(BuildContext context) async {
    SystemConfig.makeStatusBarHide();
    await SystemConfig.makeDeviceLandscape()
        .then((value) => Navigator.of(context).pop());
    return true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onTextFieldTapped() {}

  void _onMessageChanged(String value) {
    _featureImplementation();

//    setState(() {
//      message = value;
//      if (value.trim().isEmpty) {
//        isCurrentUserTyping = false;
//        return;
//      } else {
//        isCurrentUserTyping = true;
//      }
//    });
  }

  void _like() {
    _featureImplementation();
  }

  void _sendMessage() {
    _featureImplementation();
//    setState(() {
////      myMessages.insert(
////          0, (Message(messageBody: message, senderId: currentUser.userId)));
//      message = '';
//      _txtController.text = '';
//    });
//    _scrollToLast();
  }

  void _scrollToLast() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _featureImplementation() {
    _scafoldKey.currentState.showSnackBar(SnackBar(
      content: Container(height: 60, child: FeatureImplement()),
    ));
  }

  Widget _buildBottomSection() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 52,
            margin: EdgeInsets.all(minValue),
            padding: EdgeInsets.symmetric(horizontal: minValue),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(minValue * 4))),
            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.insert_emoticon,
                  size: iconSize,
                ),
                SizedBox(
                  width: minValue,
                ),
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    keyboardType: TextInputType.text,
                    controller: _txtController,
                    onChanged: _onMessageChanged,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message"),
                    autofocus: false,
                    onTap: () => onTextFieldTapped(),
                  ),
                ),
                Icon(
                  Icons.attach_file,
                  size: iconSize,
                ),
                isCurrentUserTyping
                    ? Container()
                    : Icon(
                        Icons.camera_alt,
                        size: iconSize,
                      ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: minValue),
          child: FloatingActionButton(
            onPressed: () => isCurrentUserTyping ? _sendMessage() : _like(),
            child: Icon(isCurrentUserTyping ? Icons.send : Icons.thumb_up),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of(context).dataManager.authUser.user;

//    _handleRotation();
    //print("Orientation In Chat Screen: ${MediaQuery.of(context).orientation}");

    return WillPopScope(
      onWillPop: () => _onBackTap(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          key: _scafoldKey,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("${widget.user.name}"),
                Text(
                  "ONLINE",
                  style: TextStyle(color: greenColor, fontSize: 10),
                ),
//              CircleAvatar(
//                backgroundColor: greenColor,
//                radius: 4,
//              )
              ],
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
//              Expanded(
//                child: MyChatListBuilder(
//                  stream: widget.bloc.supportChat$,
//                  builder: (context, List<SupportItem> data) {
//                    return ListView.builder(
//                        reverse: true,
//                        shrinkWrap: true,
//                        controller: _scrollController,
//                        padding: EdgeInsets.symmetric(
//                            vertical: minValue * 2, horizontal: minValue),
//                        itemCount: data.length,
//                        itemBuilder: (context, index) {
//                          final SupportItem item = data[index];
//                          if (item is Suggestion) {
//                            return MySuggestion(
//                              suggestion: item,
//                            );
//                          } else if (item is SupportChat) {
//                            return MyChatTile(
//                              chat: item,
//                              isMe: item.user.id == userModel.userId,
//                            );
//                          } else {
//                            return Container();
//                          }
//                        });
//                  },
//                ),
//              ),
                Expanded(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomSection(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
