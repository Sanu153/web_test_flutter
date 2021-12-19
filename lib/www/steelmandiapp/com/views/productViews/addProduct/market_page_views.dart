import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/market_grouping.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/market_list_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/addProduct/save_product_btn.dart';

class MyMarketPageView extends StatefulWidget {
  final MarketBloc marketBloc;
  final int productSpecId;
  final bool showDetail; // When user Tap On TabBar Item

  MyMarketPageView(
      {@required this.marketBloc,
      @required this.productSpecId,
      this.showDetail = false});

  @override
  _MyMarketPageViewState createState() => _MyMarketPageViewState();
}

class _MyMarketPageViewState extends State<MyMarketPageView> {
  MarketBloc _marketBloc;
  double minValue = 8.0;

  Future<ResponseResult> _responseResult;

//  void _onCreate() async {
//    if (_marketBloc.actionState != ActionState.INITIAL) {
//      int firstSpecId = Provider.of(context).dataManager.addProductDialogSpecId;
//      ////print("The First*******: ${firstSpecId}");
//      _responseResult = _marketBloc.getProductSpecMarket(firstSpecId);
//    }
//  }
  Future<void> _showDetail() async {
    final ResponseResult _result =
        await _marketBloc.getAddProductSpecMarket(widget.productSpecId);
  }

  @override
  void initState() {
    super.initState();
    _marketBloc = widget.marketBloc;
    _marketBloc.makeInitial();
    if (widget.showDetail) {
      _showDetail();
    }
  }

  Widget _buildMarketGrouping(String name) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: minValue),
      child: Text(
        name,
        style:
            Theme.of(context).textTheme.subtitle2.apply(color: Colors.white70),
      ),
    );
  }

  Widget _buildBody(List<MarketGrouping> items) {
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    final UserProduct currentUserProduct = _productBloc.getCurrentUserProduct;

    return Container(
        child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(bottom: minValue * 8, top: minValue),
            itemBuilder: (context, index) {
              final item = items[index];
              if (item is HeaderPoint) {
                return _buildMarketGrouping(item.groupingName);
              } else if (item is ProductSpecMarket) {
                bool isSelected = false;
                if (widget.showDetail) {
                  currentUserProduct.productSpecMarketList
                      .forEach((key, value) {
                    if (item.id == key) {
                      isSelected = true;
                      ////print("Key: $key and Value: $value");
                      ////print("Product Spec Market Id: ${item.id}");
                    }
                  });
                }
                ////print("------------------");

                return MyMarketListTile(
                  productSpecMarket: item,
                  isSelected: isSelected,
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _buildHeaderRow() {
    return Container(
      height: 25.0,
      padding: EdgeInsets.only(top: minValue, left: minValue),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "MARKETS",
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .apply(color: Colors.white60, fontWeightDelta: 1),
                      ),
                    ),
                  ),
//                  Expanded(
//                    child: Align(
//                      alignment: Alignment.centerRight,
//                      child: InkWell(
//                          child: Icon(
//                            Icons.search,
//                            size: 20.0,
//                            color: Colors.white60,
//                          ),
//                          onTap: () {
//                            showSearch(
//                                context: context,
//                                delegate: MarketSearchDelegate());
//                          }),
//                    ),
//                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "MIN",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.white60, fontWeightDelta: 1),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "MAX",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.white60, fontWeightDelta: 1),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "ACTIONS",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .apply(color: Colors.white60, fontWeightDelta: 1),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildError(Failure failure) {
    return Center(
      child: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: 310,
        child: ResponseFailure(
          subtitle: failure.responseMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          decoration: BoxDecoration(
              border: Border(right: BorderSide(color: primaryColorDark))),
          child: Column(
            children: <Widget>[
//          _buildHeader(),
              _buildHeaderRow(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: minValue),
                  child: StreamMania<MarketGrouping>(
                    onWaiting: (context) {
                      ////print("On Waiting");
                      return MyComponentsLoader(
                        color: Colors.orange,
                      );
                    },
                    stream: _marketBloc.userSpecMarketState$,
                    onError: (context, Failure failure) {
                      return _buildError(failure);
                    },
                    onFailed: (context, Failure failure) {
                      return _buildError(failure);
                    },
                    onSuccess: (context, List<MarketGrouping> data) {
                      ////print("Item data: $data");
                      return _buildBody(data);
//        return _buildBody(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        widget.showDetail
            ? Align(
                alignment: Alignment.bottomRight,
                child: MySaveProductSaveBtn(
                  showDetail: true,
                ),
              )
            : Container()
      ],
    );
  }
}
