import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/my_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/homeViews/landscape_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/observer.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  makeDeviceOrientation() async {}

  void onCreate() async {
    await SystemConfig.makeDeviceLandscape();

//    //print("On Home Created");
//    _productBarBloc = Provider.of(context).fetch(ProductBarBloc);
//    await _productBarBloc.getSelectedProductBarList();
//    //print(
//        "User Data From Home: ${_productBarBloc.dataManager.authenticationToken}");
//    //print("User Data Is Null: ${_productBarBloc.authModel == null}");
  }

  @override
  void didChangeDependencies() {
    onCreate();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      onWaiting: (context) {
        return MyLoaderScreen();
      },
      onSuccess: (context, List data) {
        ProductState state = data[0];
//        List<ProductBar> _productDataList = data[1];

        if (state == ProductState.LOADER) {
          //print("Loading State");
          return MyLoaderScreen(
            backgroundColor: Theme.of(context).primaryColor,
            spinnerColor: Colors.white,
          );
        } else if (state == ProductState.FAILED) {
          //print("Data Not Available");
          return Container();
        } else if (state == ProductState.FAILED) {
          //print("Failed");
          return Container();
        } else {
          return MyLandScapeHomeScreen();
        }
      },
    );
  }
}
