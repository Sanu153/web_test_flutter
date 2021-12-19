import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_sepeartor.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/product_list_views.dart';

class MyProductPageView extends StatefulWidget {
  final ProductBloc productBloc;

  MyProductPageView({@required this.productBloc});

  @override
  _MyProductPageViewState createState() => _MyProductPageViewState();
}

class _MyProductPageViewState extends State<MyProductPageView> {
  ProductBloc _productBloc;
  double minValue = 8.0;

  Future<ResponseResult> _responseResult;
  ResponseResult _resResult;
  MarketBloc _mBloc;

  void _onCreate() async {
    _mBloc = Provider.of(context).fetch(MarketBloc);

    _responseResult = _productBloc.getAllProductAddList();
    _resResult = await _responseResult;
    int _specId = Provider
        .of(context)
        .dataManager
        .addProductDialogSpecId;

    //print("Id: $_specId");
    await _mBloc.getAddProductSpecMarket(_specId);
  }

  @override
  void dispose() {
    _mBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _productBloc = widget.productBloc;
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _onCreate();
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: minValue,
      ),
      child: Text(
        "PRODUCTS",
        style: Theme.of(context)
            .textTheme
            .caption
            .apply(color: Colors.white60, fontWeightDelta: 1),
      ),
    );
  }

  /// Category

  Widget _buildCategoryHeader(BuildContext context, String name) {
    return Text(
      name,
      style: Theme
          .of(context)
          .textTheme
          .subhead
          .apply(color: Colors.white60, heightFactor: 2, fontWeightDelta: 1),
    );
  }

  SizedBox get defaultS =>
      SizedBox(
        width: minValue,
      );

  Widget _buildListBuilder(List<ProductItem> items) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is ProType) {
            return Container(
                margin: EdgeInsets.only(
                    top: index == 0 ? 3 : minValue + 5, bottom: minValue - 2),
                child: _buildCategoryHeader(context, item.name));
          } else if (item is Product) {
            return MyRowTile(
              index: index,
              product: item,
            );
          } else {
            return Container(
              child: Text(
                "No Products Available",
                style: TextStyle(color: Colors.yellowAccent),
              ),
            );
          }
        });
  }

  Widget _buildBody(List<ProductItem> items) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: primaryColorDark))),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: minValue),
              child: _buildListBuilder(
                items,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureObserver(
      onWaiting: (context) {
        //print("On Waiting");
        return MyComponentsLoader(
          color: Colors.orange,
        );
      },
      future: _responseResult,
      onError: (context, Failure failure) {
        return Center(
          child: Container(
            color: Theme.of(context).primaryColor,
            width: MediaQuery.of(context).size.width,
            child: ResponseFailure(
              subtitle: failure.responseMessage,
            ),
          ),
        );
      },
      onSuccess: (context, List<ProductItem> data) {
        //print("Item data: $data");
        return _buildBody(data);
//        return _buildBody(context);
      },
    );
  }
}
