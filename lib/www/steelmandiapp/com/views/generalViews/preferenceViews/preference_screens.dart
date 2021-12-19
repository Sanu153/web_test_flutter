import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/authBloc/authentication_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/my_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_category.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/prefer_header.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/product_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/product_specs_markets.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/product_type_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/homeViews/landscape_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';

class MyprefernceScreen extends StatefulWidget {
  final bool wilExit;

  MyprefernceScreen({this.wilExit});

  @override
  _MyprefernceScreenState createState() => _MyprefernceScreenState();
}

class _MyprefernceScreenState extends State<MyprefernceScreen> {
  Future<ResponseResult> _futureResult;

  ProductCategory _selectedCategoryM;
  Product _selectedProductM;
  ProductSpec _selectedProductSpecM;

//  List<int> _marketList;
  Map<int, List> marketIdWithName;

  ProductSpec get previousSelectedSpec => _selectedProductSpecM;

  var _minPadding = 8.0;

  ProductBloc productBloc;
  AuthenticationBloc _authenticationBloc;

  DataManager dataManager;

  void _moveToDash(bool skip) async {
    bool result =
        await _authenticationBloc.savePreferValue(newUser: false, prefer: true);
    if (result) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyLandScapeHomeScreen(
//                    hasDefault: skip,
                    productBloc: productBloc,
                  )),
          (Route<dynamic> route) => false);
    } else {
      //print("Preference is Not Updated: Not Skipped");
    }
  }

  void _onPreferSubmit(BuildContext context) async {
    try {
      if (_selectedProductSpecM != null && marketIdWithName.length != 0) {
        dataManager.selectedProductSpec = _selectedProductSpecM;
        dataManager.mapMarketIdWithName = marketIdWithName;
        dataManager.selectedProductId = _selectedProductM.id;

        // Add To Product
        await productBloc.addProductFromAdder();
        _moveToDash(false);

//      UserProduct result = await productBloc.saveProductToLocal(
//        productId: _selectedProductM.id,
//        spec: _selectedProductSpecM,
//        mapMarketList: marketIdWithName,
//      );
//      await Future.delayed(Duration(seconds: 2));
        //print(result);
//        result != null
//            ? _moveToDash(false)
//            : _showSnacks(context, "Data is not saved");
      } else {
        _showSnacks(context, null);
      }
    } catch (e) {
      print("Error in Submitting Preference: ${e.toString()}");
      _showSnacks(context, e.toString());
    }
  }

  void _showSnacks(BuildContext context, String title) {
    final snackbar = SnackBar(
      content: Text("${title ?? 'Field can not blank'}"),
      backgroundColor: redColor,
      elevation: 5.0,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void callService() async {
    _futureResult = productBloc.getProductList();
    await SystemConfig.makeStatusBarVisible();
    marketIdWithName = Map<int, List>();
  }

  @override
  void didChangeDependencies() {
    productBloc = Provider.of(context).fetch(ProductBloc);
    _authenticationBloc = Provider.of(context).fetch(AuthenticationBloc);
    dataManager = Provider.of(context).dataManager;
    callService();
    super.didChangeDependencies();
  }

  void _onProductCategoryChanged(ProductCategory category) {
    if (!mounted) return;
    setState(() {
      _selectedCategoryM = category;
      _selectedProductM = null;
      _selectedProductSpecM = null;
//      _selectedMarketM = null''
    });
    Navigator.of(context).pop();
  }

  void _onProductChanged(Product product) {
    setState(() {
      _selectedProductM = product;
      _selectedProductSpecM = null;
    });
    Navigator.of(context).pop();
  }

  void _onProductSpecChanged(ProductSpec spec) async {
    Navigator.of(context).pop();

    await productBloc.getProductSpecMarket(spec.id);
    setState(() {
      _selectedProductSpecM = spec;
      marketIdWithName = {};
    });
    //print("Market List On ProductSpec Changed: $marketIdWithName");
  }

  void _openDialog(int type) async {
    Widget child = Container();

    if (type == 0) {
      child = MyProductTypeList(
        onChanged: _onProductCategoryChanged,
      );
      DialogHandler.openPreferenceDialog(
          title: "Product Category", context: context, child: child);
    } else if (type == 1) {
      child = MyProductList(
        onChanged: _onProductChanged,
        category: _selectedCategoryM,
      );
      DialogHandler.openPreferenceDialog(
          title: "Product Category", context: context, child: child);
    } else if (type == 2) {
      child = MyProductSpecList(
        onChanged: _onProductSpecChanged,
        product: _selectedProductM,
      );
      DialogHandler.openPreferenceDialog(
          title: "Product Specification", context: context, child: child);
    }
  }

  Widget _buildProductType() {
    return ListTile(
      onTap: () => _openDialog(0),
      title: Text("Product Category *"),
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: _minPadding),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.grey[500]))),
        child: Align(
          alignment: Alignment.centerLeft,
          child: _selectedCategoryM == null
              ? Text("Choose category")
              : Text(
                  "${_selectedCategoryM.productTypeName}",
                  style: Theme.of(context).textTheme.title,
                ),
        ),
      ),
    );
  }

  Widget _buildProduct() {
    return ListTile(
      onTap: () => _openDialog(1),
      title: Text("Product *"),
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: _minPadding),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.grey[500]))),
        child: Align(
            alignment: Alignment.centerLeft,
            child: _selectedProductM == null
                ? Text("Choose product")
                : Text(
                    "${_selectedProductM.productName}",
                    style: Theme.of(context).textTheme.title,
                  )),
      ),
    );
  }

  Widget _buildProductSpecs() {
    return ListTile(
      onTap: () => _openDialog(2),
      title: Text("Product Specifications *"),
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: _minPadding),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.grey[500]))),
        child: Align(
            alignment: Alignment.centerLeft,
            child: _selectedProductSpecM == null
                ? Text("Choose product specifications")
                : Text(
                    "${_selectedProductSpecM.name}",
                    style: Theme.of(context).textTheme.title,
                  )),
      ),
    );
  }

  Widget _buildBottom() {
    final t = Theme.of(context).textTheme.title;
    return Builder(
      builder: (BuildContext context) {
        return Container(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.all(_minPadding * 2),
            onPressed: () => _onPreferSubmit(context),
            textColor: Colors.white,
            disabledElevation: 0.0,
            disabledColor: Colors.red[300],
            elevation: 0.0,
            child: Text("SUBMIT", style: t.apply(color: Colors.white)),
          ),
//                shape: RoundedRectangleBorder(
//                    borderRadius:
//                        BorderRadius.all(Radius.circular(_minPadding * 4)))
        );
      },
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//            _buildDeafultCase(),
          Expanded(
            child: ListView(
//                mainAxisAlignment: MainAxisAlignment.start,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              children: <Widget>[
                MyPreferHeader(),
                SizedBox(
                  height: _minPadding * 2,
                ),
                _buildProductType(),
                SizedBox(
                  height: _minPadding,
                ),
                _buildProduct(),
                SizedBox(
                  height: _minPadding,
                ),
                _buildProductSpecs(),
                _selectedProductSpecM == null
                    ? Container()
                    : MyProductSpecMarket(
                        productSpecId: _selectedProductSpecM.id,
                        onChanged: (Map<int, List> _marketIdWithName) {
                          marketIdWithName = _marketIdWithName;
                          //print("MarketList On Changed: $marketIdWithName");
                        },
                      ),
                SizedBox(
                  height: _minPadding * 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildBottom(),
                ),
                SizedBox(
                  height: _minPadding * 2,
                ),
              ],
            ),
          ),
//            Align(
//              alignment: Alignment.bottomCenter,
//              child: _buildBottom(),
//            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.grey[50],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "SKIP",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: () {
              _moveToDash(true);
            },
          ),
        ],
      ),
      body: FutureObserver(
        onWaiting: (context) {
          //print("On Waiting");
          return MyLoaderScreen();
        },
        future: _futureResult,
        onError: (context, Failure failure) {
          return Center(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ResponseFailure(
                    title: "Products not available",
                    subtitle:
                        "Please check your connection settings and try again",
                    hasImageDisplay: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                          onPressed: () => callService(),
                          color: Colors.blueGrey[900],
                          textColor: Colors.white,
                          icon: Icon(Icons.refresh),
                          label: Text(
                            "RETRY",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(
                        width: _minPadding * 2,
                      ),
                      RaisedButton.icon(
                          onPressed: () => _moveToDash(true),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          icon: Icon(Icons.skip_next),
                          label: Text(
                            "SKIP",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  )
                ],
              ),
            ),
          );
        },
        onSuccess: (context, List<ProductCategory> data) {
          //print("Preference List data: $data");

          return _buildBody();
//        return _buildBody(context);
        },
      ),
    );
  }
}
