import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';

class MyRowTile extends StatefulWidget {
  final Product product;
  final int index;
  final Function onProductChange;

  MyRowTile({
    this.product,
    this.index,
    @required this.onProductChange,
  });

  @override
  _MyRowTileState createState() => _MyRowTileState();
}

class _MyRowTileState extends State<MyRowTile> {
  double minValue = 8.0;

  int _currentIndex = -9999999;

  int _currentSpecId = -999999999;

  String url =
      "https://cdn.pixabay.com/photo/2014/03/10/11/27/periscope-284421__340.jpg";

  String url2 =
      "https://cdn.pixabay.com/photo/2016/09/22/12/41/teapot-1687283__340.jpg";

  ProductBloc _productBloc;
  DataManager _dataManager;

  void _onCreate() async {
    if (widget.index == 1) {
      // Default First Product To Be Opened;
      _currentIndex = widget.product.id;
      _currentSpecId = 0;
      // Updating First Index Of ProductSpec To State
      if (widget.product.productSpecs.length != 0) {
        _dataManager.selectedProductSpec = widget.product.productSpecs[0];
        _dataManager.selectedProductId = widget.product.id;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productBloc = Provider.of(context).fetch(ProductBloc);
    _dataManager = Provider.of(context).dataManager;
    _onCreate();
  }

  void _onSpecChange(int index, MarketBloc marketBloc, ProductSpec spec) async {
    int specId = spec.id;
    setState(() {
      _currentSpecId = index;

      /// Updating State To Current Local Id
      _dataManager.addProductDialogSpecId = specId;
      // Updating Current Selected Spec
      _dataManager.selectedProductSpec = spec;
      // Clear Previous MarketIds From State
      _dataManager.mapMarketIdWithName = {};
      _dataManager.notifyMarketListIds = [];
    });
//    //print("addProductDialogSpecId: ${_dataManager.addProductDialogSpecId}");
    await marketBloc.getAddProductSpecMarket(specId);
  }

  void _onProductChange() {
    setState(() {
      if (_currentIndex == widget.product.id) {
        _currentIndex = -9999999;
      } else {
        _currentIndex = widget.product.id;
        _dataManager.selectedProductId = widget.product.id;
      }
    });
  }

  Widget _buildLeading() {
    return CircleAvatar(
      backgroundColor: widget.index == 0
          ? greenColor
          : widget.index % 2 == 0 ? Colors.redAccent : Colors.yellowAccent,
      backgroundImage: NetworkImage(
        widget.index % 2 == 0 ? url : url2,
      ),
      child: Container(),
      radius: minValue * 1.3,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      child: Text(
        "${widget.product.productName} (${widget.product.productSpecs.length})",
        style: Theme.of(context)
            .textTheme
            .subtitle
            .apply(color: Colors.white70, fontWeightDelta: 1),
      ),
    );
  }

  SizedBox get defaultS => SizedBox(
        width: minValue,
      );

  Widget _buildNodata() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: minValue * 2),
      child: Center(
        child: Text(
          "No Specifications Available",
          style: Theme.of(context)
              .textTheme
              .caption
              .apply(color: Colors.red[300], fontWeightDelta: 1),
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    final _url = Provider.of(context).dataManager.defaultProductSpecIcon;
    final MarketBloc _marketBloc = Provider.of(context).fetch(MarketBloc);

    return Column(
      children: <Widget>[
        Opacity(
          opacity: _currentIndex == widget.product.id ? 1.0 : 0.6,
          child: InkWell(
            splashColor: Colors.blueGrey[700],
            onTap: () => _onProductChange(),
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: minValue, horizontal: minValue - 4),
//                color: _currentIndex == widget.product.id
//                    ? Colors.blueGrey[700]
//                    : Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _buildLeading(),
                          defaultS,
                          Flexible(child: _buildTitle(context)),
                          defaultS,
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: _currentIndex == widget.product.id
                            ? Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white70,
                              )
                            : Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white70,
                              )),
                  ],
                )),
          ),
        ),
        SizedBox(
//          height: index == 1 ? 150.0 : 0,
            child: _currentIndex == widget.product.id
                ? widget.product.productSpecs.length == 0
                    ? _buildNodata()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.only(
                            left: minValue * 2,
                            top: minValue,
                            bottom: minValue),
                        itemCount: widget.product.productSpecs.length,
                        itemBuilder: (context, index) {
                          ProductSpec _spec =
                              widget.product.productSpecs[index];
                          return InkWell(
                            onTap: () =>
                                _onSpecChange(index, _marketBloc, _spec),
                            splashColor: Colors.blueGrey[800],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: minValue + 2,
                                  horizontal: minValue * 2),
                              decoration: BoxDecoration(
                                  color: _currentSpecId == index
                                      ? Colors.blueGrey[900]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(minValue - 2))),
                              child: Text(
                                "${_spec.name ?? _spec.dispName}",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .apply(
                                        color: _currentSpecId == index
                                            ? Colors.white
                                            : Colors.white60),
                              ),
                            ),
                          );
                        })
                : Container())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList(context);
  }
}
