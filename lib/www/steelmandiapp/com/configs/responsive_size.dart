import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';

class ResponsiveSize {
  static bool smallDevice = false;
  static bool mediumDevice = false;
  static bool largeDevice = false;
  static double deviceWidth = 640;
  static double deviceHeight = 320;
  static double dashboardContentHeight = 0.0;

  void initSize(BuildContext context) {
    final DataManager _manger = Provider.of(context).dataManager;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    final Orientation or = MediaQuery.of(context).orientation;
    double sideBarWidth = deviceWidth / 15;
    double bottomNavHeight = 25.0;
    double fromTop = deviceHeight / 8.4;

    double selectedMarketSize = deviceWidth / 5.2;
    double buySellRequestDialogWidth = deviceWidth / 2.5;
    double keyPadDialogSize = deviceWidth / 4;
    double sidebarDrawerWidth = 300.0;
    double bottomNavDialogSize = 250.0;

//    //print(
//        "sideBarWidth Before: ${_manger.coreSettings.sideBarWidth} and After: $sideBarWidth");
//    //print(
//        "bottomNavHeight Before: ${_manger.coreSettings.bottomNavHeight} and After: $bottomNavHeight");
//    //print(
//        "fromTop Before: ${_manger.coreSettings.fromTop} and After: $fromTop");
//    //print(
//        "selectedMarketSize Before: ${_manger.coreSettings.selectedMarketSize} and After: $selectedMarketSize");
//    //print(
//        "buySellRequestDialogWidth Before: ${_manger.coreSettings.buySellRequestDialogWidth} and After: $buySellRequestDialogWidth");
//    print(
//        "keyPadDialogSize Before: ${_manger.coreSettings.keyPadDialogSize} and After: $keyPadDialogSize");

    int maxAppbarLength = 0;

    //print("Device Width: $deviceWidth");
    //print("Device Height: $deviceHeight");

    if (or == Orientation.landscape) {
      final _sidebarDrawerWidth = (deviceWidth - sideBarWidth) / 2;

      if (deviceWidth > 720) {
        maxAppbarLength = 4;

        largeDevice = true;
      } else if (deviceWidth <= 720 && deviceWidth >= 640) {
        maxAppbarLength = 3;
        smallDevice = true;
        keyPadDialogSize = 200.0;
      }
      _manger.coreSettings = CoreSettings(
          sidebarDrawerWidth: _sidebarDrawerWidth,
          maxAppbarLength: maxAppbarLength,
          selectedMarketSize: selectedMarketSize,
          sideBarWidth: sideBarWidth,
          fromTop: fromTop,
          buySellRequestDialogWidth: buySellRequestDialogWidth,
          bottomNavHeight: bottomNavHeight,
          keyPadDialogSize: keyPadDialogSize);
      dashboardContentHeight = deviceHeight - (fromTop + bottomNavHeight);
    }
  }
}
