import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/dialog/custom_dialog_views.dart';

class DialogHandler {
  static Future<void> openAlertDialog(
      {@required BuildContext context,
      @required String title,
      @required Widget widget,
      List<Widget> actions,
      bool isBarrier = true}) {
    showDialog(
        barrierDismissible: isBarrier,
        //restrict clicking outside of the dialog to dismiss the window
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title), content: widget, actions: actions);
        });
  }

  static openBuyTextFieldDialog(
      {@required BuildContext context, @required Function onChanged}) {
    final TextEditingController _controller = TextEditingController();
    final subhead = Theme.of(context).textTheme.subhead;
    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      context: context,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: true,
      transitionBuilder: (context, a1, a2, ch) {
        return AlertDialog(
          title: Text("Set place for request"),
          content: TextField(
            keyboardType: TextInputType.text,
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              labelStyle: subhead,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CLOSE"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("SAVE"),
              onPressed: () {
                onChanged(_controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> openBuySellRequestDialog(
      {@required BuildContext context, Widget child, bool autoHeight = false}) {
    final settings = Provider.of(context).dataManager.coreSettings;
    double space = 1.0;
    final height = double.infinity;
    return showGeneralDialog<void>(
      barrierColor: Colors.black.withOpacity(0.1),
      barrierLabel: '',
      context: context,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: true,
      transitionBuilder: (context, a1, a2, ch) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
            transform: Matrix4.translationValues(0.0, 0.0, 0.0),
            child: MyCustomBuySellDialog(
              backgroundColor: buySellBackground,
              minWidth: settings.selectedMarketSize,
              padding: EdgeInsets.only(
                  right: settings.selectedMarketSize,
                  top: settings.fromTop + space,
                  bottom: settings.bottomNavHeight + space),
              alignment: Alignment.topRight,
              child: SizedBox(
                  width: settings.selectedMarketSize,
                  height: height,
                  child: child),
            ));
      },
    );
  }

  static Future<void> confirmBuySellDialog(
      {@required BuildContext context, Widget child, bool isBar}) {
    final settings = Provider.of(context).dataManager.coreSettings;
    double space = 1.0;
    final height = double.infinity;
    return showGeneralDialog<void>(
      barrierColor: Colors.black.withOpacity(0.1),
      barrierLabel: '',
      context: context,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: isBar ?? false,
      transitionBuilder: (context, a1, a2, ch) {
        return MyCustomBuySellDialog(
          backgroundColor: buySellBackground,
          minWidth: settings.selectedMarketSize,
          padding: EdgeInsets.only(
              top: settings.fromTop, bottom: settings.bottomNavHeight),
          alignment: Alignment.topRight,
          child: SizedBox(
              width: settings.selectedMarketSize, height: height, child: child),
        );
      },
    );
  }

  static showMyCustomDialog(
      {@required BuildContext context,
      @required Widget child,
      isBarrier = true}) {
    final settings = Provider.of(context).dataManager.coreSettings;

    return showGeneralDialog<void>(
        barrierColor: Colors.black.withOpacity(0.1),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: isBarrier,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0.0, 0.0),
            child: child,
          );
        });
  }

  static Future<void> showMyBottomSidebarDialog(
      {@required BuildContext context,
      @required Widget child,
      isBarrier = true}) {
    final settings = Provider.of(context).dataManager.coreSettings;

    return showGeneralDialog<void>(
        barrierColor: Colors.black.withOpacity(0.1),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: isBarrier,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, 0.0, 0.0),
            child: MyCustomBuySellDialog(
              backgroundColor: buySellBackground,
              minWidth: 210.0,
              padding: EdgeInsets.only(
                  left: settings.sideBarWidth,
                  top: settings.fromTop,
                  bottom: settings.bottomNavHeight),
              alignment: Alignment.topLeft,
              child: SizedBox(
//                    width: settings.sidebarDrawerWidth,
                  width: settings.sidebarDrawerWidth,
                  height: double.maxFinite,
                  child: child),
            ),
          );
        });
  }

  static Future<void> openMyCustomKeyPadDialog(
      {@required BuildContext context, @required Widget child}) {
    final settings = Provider.of(context).dataManager.coreSettings;

    return showCustomDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return MyCustomBuySellDialog(
          backgroundColor: buySellBackground,
          minWidth: settings.keyPadDialogSize,
          padding: EdgeInsets.only(
              right: settings.selectedMarketSize,
              top: settings.fromTop + 10,
              bottom: settings.bottomNavHeight + 20),
          alignment: Alignment.topRight,
          child: SizedBox(
              width: settings.selectedMarketSize,
              height: double.maxFinite,
              child: child),
        );
      },
    );
  }

  static Future<void> openMySideBarDialog(
      {@required BuildContext context, @required Widget child}) {
    final settings = Provider.of(context).dataManager.coreSettings;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.1),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: MyCustomBuySellDialog(
                backgroundColor: buySellBackground,
                minWidth: settings.keyPadDialogSize,
                padding: EdgeInsets.only(
                    left: settings.sideBarWidth, top: 0.0, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: SizedBox(
//                    width: settings.sidebarDrawerWidth,
                    width: settings.sidebarDrawerWidth,
                    height: double.maxFinite,
                    child: child),
              ));
        });
  }

  // DialogWithSidebar
  static Future<void> openDialogWithSidebar(
      {@required BuildContext context, @required Widget child}) {
    final settings = Provider.of(context).dataManager.coreSettings;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.1),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: MyCustomBuySellDialog(
                backgroundColor: buySellBackground,
                minWidth: settings.keyPadDialogSize,
                padding: EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0),
                alignment: Alignment.topLeft,
                child: SizedBox(
//                    width: settings.sidebarDrawerWidth,
                    width: settings.sidebarDrawerWidth,
                    height: double.maxFinite,
                    child: child),
              ));
        });
  }

  static Future<void> footerBarDialog(
      {@required BuildContext context, @required Widget child}) {
    final settings = Provider.of(context).dataManager.coreSettings;

    return showCustomDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return MyCustomBuySellDialog(
          backgroundColor: buySellBackground,
          minWidth: settings.keyPadDialogSize,
          padding: EdgeInsets.only(
              left: settings.sideBarWidth, bottom: settings.bottomNavHeight),
          alignment: Alignment.bottomLeft,
          elevation: 0.0,
          child: SizedBox(
              width: settings.bottomNavDialogSize,
              height: settings.bottomNavDialogSize,
              child: child),
        );
      },
    );
  }

  static showMySuccessDialog(
      {@required BuildContext context,
      String title = '',
      String message = ''}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
//            backgroundColor: greenColor,
            elevation: 8.0,
            content: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 45.0,
                    backgroundColor: greenColor,
                    child: SpinKitDoubleBounce(
                      size: 50.0,
                      itemBuilder: (BuildContext context, int index) {
                        return Icon(
                          Icons.done,
                          size: 54,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "$message",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay",
                        style: Theme.of(context).textTheme.subhead)),
              )
            ],
          );
        });
  }

  static openPreferenceDialog(
      {@required BuildContext context, @required String title, Widget child}) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(5.0),
//                shape: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(6.0)),
                title: Text(title),
                content: Container(
                  height: 450.0,
                  child: child,
                ),
              ),
            ),
          );
        });
  }

  /// Product
  static openGeneralDialog(
      {@required BuildContext context, @required String title, Widget child}) {
    final DataManager manager = Provider.of(context).dataManager;
    final height = MediaQuery.of(context).size.height;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.easeIn.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 20, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: MyCustomSimpleDialogForProduct(
                  padding: EdgeInsets.only(
                      left: manager.coreSettings.sideBarWidth,
                      top: kToolbarHeight - 5),
                  child:
                      SizedBox(height: height - kToolbarHeight, child: child),
                )),
          );
        });
  }

  /// Product Detail
  static openProductDetail(
      {@required BuildContext context, @required String title, Widget child}) {
    final DataManager manager = Provider.of(context).dataManager;
    final height = MediaQuery.of(context).size.height;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.3),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.easeIn.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 20, 0.0),
            child: Opacity(
                opacity: a1.value,
                child: MyCustomSimpleDialogForProduct(
                  padding: EdgeInsets.only(
                      left: manager.coreSettings.sideBarWidth +
                          manager.coreSettings.sideBarWidth,
                      top: kToolbarHeight - 5),
                  child:
                      SizedBox(height: height - kToolbarHeight, child: child),
                )),
          );
        });
  }

  /// Negotiation Chat
  static Future<void> openPortfolioDialog(
      {@required BuildContext context, @required Widget child}) {
    final settings = Provider.of(context).dataManager.coreSettings;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.bounceInOut.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(
                  curvedValue, 0.0, curvedValue * 100),
              child: MyCustomBuySellDialog(
                backgroundColor: buySellBackground,
//                minWidth: settings.keyPadDialogSize,
                padding: EdgeInsets.only(
                    left: settings.sidebarDrawerWidth + settings.sideBarWidth),
                alignment: Alignment.topLeft,
                child: SizedBox(
//                    width: settings.sidebarDrawerWidth,
                    width: deviceWidth -
                        (settings.sidebarDrawerWidth + settings.sideBarWidth),
                    height: double.maxFinite,
                    child: child),
              ));
        });
    return showCustomDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return MyCustomBuySellDialog(
          backgroundColor: buySellBackground,
          minWidth: settings.keyPadDialogSize,
          padding: EdgeInsets.only(
              left: settings.sideBarWidth, top: 0.0, bottom: 0.0),
          alignment: Alignment.topLeft,
          child: SizedBox(
              width: settings.sidebarDrawerWidth,
              height: double.maxFinite,
              child: child),
        );
      },
    );
  }

  /// Negotiation Chat
  static Future<void> negotiationConfirmationDialog(
      {@required BuildContext context,
      @required Function onSubmit,
      Widget content,
      bool hasApproved}) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        context: context,
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        transitionBuilder: (context, a1, a2, ch) {
          final curvedValue = Curves.bounceInOut.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(
                  curvedValue, 0.0, curvedValue * 100),
              child: AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  "Confirmation",
                  style: TextStyle(color: Colors.white),
                ),
                content: content,
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "CLOSE",
                        style: TextStyle(color: Colors.white60),
                      )),
                  FlatButton(
                      onPressed: onSubmit,
                      child: Text(
                        "${hasApproved ? 'ACCEPT' : 'REJECT'}",
                        style: TextStyle(
                            color: hasApproved ? greenColor : redColor),
                      ))
                ],
              ));
        });
  }
}
