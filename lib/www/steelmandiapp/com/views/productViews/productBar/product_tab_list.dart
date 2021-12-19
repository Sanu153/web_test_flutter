import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/webSocketBloc/product_socket.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/customViews/list/custom_list_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/info/product_info.dart';

class MyProductTabList extends StatelessWidget {
  final ProductBloc productBloc;
  final GraphBloc graphBloc;
  final WebSocketBloc webSocket;

  UserProduct _selectedUserProduct;

  MyProductTabList({this.productBloc, this.graphBloc, this.webSocket});

//  TabController _tabController;

  void _setUpCurrentState() async {
    _selectedUserProduct = productBloc.getCurrentUserProduct;
    int _position =
        productBloc.getUserProductList.indexOf(_selectedUserProduct);
  }

  void _itemChanged(UserProduct product, int index) async {
    await productBloc.onAppbarUserProductChange(product);
    _setUpCurrentState();

    _graphCall();

    // Calling Socket
    webSocket.onChangeProduct();
  }

  void _onRemoveCurrentProduct(int currentIndex) async {
//    int _preIndex = _tabController.previousIndex;
    await productBloc.onRemoveAppbarUserProduct();
    _graphCall();
  }

  void _graphCall() async {
    // Call To Graph
    await graphBloc.getProductSpecMarketGraph();
  }

  void onSocket() async {}

  void neverSatisfied(BuildContext context) async {
//    final ProductBloc _productBloc = Provider.of(context).fetch(ProductBloc);

    await DialogHandler.openProductDetail(
        context: context, title: "Add Product", child: MyProductInfo());
    productBloc.resetToDefaultData();
    final MarketBloc marketBloc = Provider.of(context).fetch(MarketBloc);
    marketBloc.dispose();

    //print("Dialog Closed");
  }

  Widget _buildProductTile(int index, UserProduct userProduct,
      List<UserProduct> filteredList, BuildContext context) {
    final _currentUp = productBloc.getCurrentUserProduct;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (_currentUp.generatedId == filteredList[index].generatedId) {
            // Open Details
            //print("Show Details");
            neverSatisfied(context);
          } else {
            _itemChanged(filteredList[index], index);
          }
        },
        child: Container(
          decoration: _currentUp.generatedId == filteredList[index].generatedId
              ? BoxDecoration(
                  color: Color(0xff1f2847),
                  borderRadius: BorderRadius.all(Radius.circular(1.0)))
              : null,
          child: MyCustomListTile(
            title:
                "${userProduct.productSpecName ?? userProduct.productSpecDisplayName}",
            subtitle: "${userProduct.productSpecDisplayName ?? ''}",
            imageUrl: "${userProduct.productSpecIcon}",
            index: index,
            trailing:
                _currentUp.generatedId == filteredList[index].generatedId &&
                        filteredList.length != 1
                    ? GestureDetector(
                        onTap: () {
                          //print("Remove Product");
                          _onRemoveCurrentProduct(index);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white30,
                        ),
                      )
                    : Container(),
          ),
        ),
      ),
    );
    return OrientationBuilder(
      builder: (context, or) {
//        return Container();
        return or == Orientation.portrait
            ? Tab(
                icon: Text('Loading...'),
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//    return _buildTabList();
    return StreamMania<UserProduct>(
      stream: productBloc.userProductState$,
      onWaiting: (context) {
        return Text(
          "Loading...",
          style: TextStyle(fontSize: 12),
        );
      },
      onSuccess: (context, List<UserProduct> productList) {
        return productList == null
            ? Text(
                "Loading...",
                style: TextStyle(fontSize: 12),
              )
            : Container(
                height: kToolbarHeight,
                width: productList.length > 1
                    ? double.infinity
                    : 180, // If AppBar has one Product in List, Then size will be 180
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Row(
                    children: productList
                        .asMap()
                        .map<int, Widget>((index, UserProduct userProduct) =>
                            MapEntry(
                                index,
                                _buildProductTile(
                                    index, userProduct, productList, context)))
                        .values
                        .toList(),
                  ),
                ),
              );
      },
    );
  }
}
