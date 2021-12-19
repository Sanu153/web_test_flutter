import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_state.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/user_graph_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/market/buy_sell_counter.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_sepeartor.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/tim_frame.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/repository/productRepository/product_repository.dart';

class ProductBloc {
  DataManager dataManager;
  ProductRepository _productRepo;

  // Subjects ******************************************************************

  BehaviorSubject<UserProduct> currentActiveUserProductSubject =
      BehaviorSubject<UserProduct>();

  final BehaviorSubject<ProductState> _productSpecMarket =
      BehaviorSubject<ProductState>.seeded(ProductState.INITIAL);

  final BehaviorSubject<List<UserProduct>> _userProductSubject =
      BehaviorSubject<List<UserProduct>>();

  final BehaviorSubject<Product> _currentProductSubject =
      BehaviorSubject<Product>();
  final BehaviorSubject<UserGraph> _currentUserGraphSubject =
      BehaviorSubject<UserGraph>();

  final BehaviorSubject<int> _userProductCounterSubject =
      BehaviorSubject<int>.seeded(0);

  final BehaviorSubject<Map<Object, Object>> _userProductStateDataSubject =
      BehaviorSubject<Map<Object, Object>>();
  final BehaviorSubject<BuySellCount> _userBuySellCountSubject =
      BehaviorSubject<BuySellCount>();

  /// Streams*******************************************************************
//  Observable<ActionState> get _productState$ => _productStateSubject.stream;
//
//  Observable<Failure> get _onFailure$ => _failedSubject.stream;

  Observable<BuySellCount> get userBuySellCount$ =>
      _userBuySellCountSubject.stream;

  Observable<ProductState> get productSpecMArket$ => _productSpecMarket.stream;

  // User Product Stream
  Observable<List<UserProduct>> get userProduct$ => _userProductSubject.stream;

  // User Product Counter
  Observable<int> get userProductCounter$ => _userProductCounterSubject.stream;

  Observable<UserProduct> get currentActiveUserProduct$ =>
      currentActiveUserProductSubject.stream;

  Observable<Product> get currentSelectedProduct$ =>
      _currentProductSubject.stream;

  Observable<UserGraph> get userGraph$ => _currentUserGraphSubject.stream;

  // Combined Streams **********************************************************
  Observable<Map<dynamic, dynamic>> get userProductState$ =>
      _userProductStateDataSubject.stream;

  /// Graph Combined Stream

  ProductBloc({this.dataManager}) {
    _productRepo = ProductRepository(dataManager);
//    onUserProductListen();
  }

  ProductRepository get getRepository => _productRepo;

  // ************** Getters **************************************************//
  UserProduct get getCurrentUserProduct =>
      currentActiveUserProductSubject.value;

  BuySellCount get currentBuySellCount => _userBuySellCountSubject.value;

  ProductSpec get currentSelectedProductSpecG =>
      _currentProductSubject.value == null
          ? null
          : _currentProductSubject.value.productSpecs[0];

  int get getTotalUserProductCount => _userProductSubject.value.length;

  List<UserProduct> get getUserProductList => _userProductSubject.value;

  int get getMaximumAppbarLength =>
      dataManager.coreSettings.maxAppbarLength ?? 4;

  // *********** Ui Actions *****************************************************//

  // Update Current UserProduct to Stream and State

  // Listeners
  void onUserProductListen() {
    currentActiveUserProductSubject.listen((UserProduct up) {
      ////print("Product Changed -----------------");
      // ResetBuySellCounter
      updateBuySellCounter(BuySellCount());
    });
  }

  void updateCurrentSelectedProduct(Product product) {
    _currentProductSubject.add(product);
  }

  // Update Counter;
  void updateBuySellCounter(BuySellCount counter) =>
      _userBuySellCountSubject.sink.add(counter);

  void updateDataFieldToCurrentProduct(UserProduct _prod) =>
      _updateActiveProduct(_prod);

  void _updateActiveProduct(UserProduct _prod) {
    dataManager.userProductSpec = _prod;

    currentActiveUserProductSubject.sink.add(_prod);

    // Updating To Stream and CurrentUserProduct as Well
    _userProductStateDataSubject.sink.add({
      ActionState: ActionState.SUCCESS,
      UserProduct: _userProductSubject.value,
      CurrentUserProduct: _prod,
    });
  }

  void _updateUserProductListToState(List<UserProduct> _upList) async {
    dataManager.userProductSpecL = _upList;
    _userProductSubject.sink.add(_upList);

    /// Total UserProductLength added to stream
    _userProductCounterSubject.sink.add(_upList.length);
  }

  /// Handle Current Active Product On Appbar
  Future<void> onAppbarUserProductChange(UserProduct product) async {
    // Save Active UserProductId To Local DataDB
    bool _result =
        await _productRepo.saveLastActiveProductId(product.generatedId);
    _updateActiveProduct(product);
  }

  Future<void> onRemoveAppbarUserProduct() async {
    final Map<Object, Object> _initialMap = {};
    int _result = await _productRepo
        .deleteAndUpdateCurrentProduct(getCurrentUserProduct.generatedId);
    ////print("result: $_result");
    if (_result == 1 || _result > 0) {
      final int _currentPosition =
          getUserProductList.indexOf(getCurrentUserProduct);
      ////print("Position Of Product: $_currentPosition");
      UserProduct _predictProduct;

      // Predict Active Product
      if (getCurrentUserProduct == getUserProductList.first) {
        // Update Current UserProduct To Next 0 => 0 + 1;
        ////print("First: Update Current UserProduct To Next 0 => 0 + 1");
        _predictProduct = getUserProductList[_currentPosition + 1];
      } else {
        ////print("Last: Update Current UserProduct To $_currentPosition - 1");
        _predictProduct = getUserProductList[_currentPosition - 1];
      }
      final latestData = getUserProductList;
      ////print("Before Remove ProductList Length: ${latestData.length}");

      latestData.remove(getCurrentUserProduct);
      ////print("After Remove ProductList Length: ${latestData.length}");
      _updateUserProductListToState(latestData);

      await _productRepo.saveLastActiveProductId(_predictProduct.generatedId);
      _updateActiveProduct(_predictProduct);

      // Upate To Stream
      _initialMap[UserProduct] = latestData;
      _initialMap[ActionState] = ActionState.SUCCESS;
      _userProductStateDataSubject.sink.add(_initialMap);
    }
  }

  // Filter ProductSpecMarkets on Selected ProductSpec
  Future<void> filterProductSpecMarket() async {
    final UserProduct _userProduct = getCurrentUserProduct;
//    final ProductSpec _currentSpec = dataManager.selectedProductSpec;
//    int _specId = dataManager.addProductDialogSpecId;
    Map<int, List> _specList = dataManager.mapMarketIdWithName;
    if (_specList != null && _specList.length != 0) {
      _userProduct.productSpecMarketList = _specList;

      int _result =
          await _productRepo.saveAndUpdateToLocal(localProduct: _userProduct);
      if (_result > 0) {
        ////print("Data Updated Successfullly/////");
        _updateActiveProduct(_userProduct);
      } else {
        ////print("Data Not Updated **");
      }
    }
    resetToDefaultData();
  }

  // Add Product Spec Item
  Future<void> addProductFromAdder() async {
    final Map<Object, Object> _initialMap = {};
    try {
      final ProductSpec _currentSpec = dataManager.selectedProductSpec;
//      int _specId = dataManager.addProductDialogSpecId;
      Map<int, List> _specList = dataManager.mapMarketIdWithName;
//      print("Current Spec: ${_currentSpec.name}");
//      print("Current Spec Market List: ${_specList}");
      if (_currentSpec != null && _specList != null && _specList.length != 0) {
        UserProduct _up = await saveProductToLocal(
            productId: dataManager.selectedProductId,
            spec: _currentSpec,
            mapMarketList: _specList);
        if (_up != null) {
          ////print("Adding Product To Stream and State: Success");
          final _latestUserProductList = getUserProductList;

          if (getTotalUserProductCount < getMaximumAppbarLength) {
//            print("Added To New One");
            _latestUserProductList.add(_up);
          } else {
//            print("Added n Replacing The First Index of List");
            // Remove and Replace First index
            int _result = await _productRepo.deleteAndUpdateCurrentProduct(
                _latestUserProductList[0].generatedId);
            _latestUserProductList.removeAt(0);
            _latestUserProductList.insert(0, _up);
          }
          _userProductSubject.sink.add(_latestUserProductList);
          _initialMap[UserProduct] = _latestUserProductList;
          _initialMap[ActionState] = ActionState.SUCCESS;
          _userProductStateDataSubject.sink.add(_initialMap);
          // Save CurrentId
          _productRepo.saveLastActiveProductId(_up.generatedId);
        } else {
          print("Adding Product To Stream and State: Failed");
        }
      } else {
        print("Some Data Not Avialable");
      }
    } catch (e) {
      print(e.toString());
    }

    // Reset Ids after Saving Successfully
    resetToDefaultData();
  }

  void resetToDefaultData() {
    // Reset Ids after Saving Successfully
    //print('Reset To Defaut called');
    dataManager.addProductDialogSpecId = 0;
    dataManager.mapMarketIdWithName = {};
    dataManager.notifyMarketListIds = [];
    dataManager.selectedProductSpec = null;
  }

  // Update Graph Data
  void updateGraphData(UserGraph userGraph) {
//    UserProduct _up = getCurrentUserProduct;
//    _up.userGraph = userGraph;
//    _updateActiveProduct(_up);
  }

  /// ******* REPOSITORY TO LOCAL-DATABASE ************** ///

// Save Product Data Set
  Future<UserProduct> saveProductToLocal(
      {ProductSpec spec,
      int productId,
      Map<int, List> mapMarketList,
      BuySellCount count}) async {
    final _generatedId =
        "${spec.id}+${mapMarketList.toString()}+${Random().nextInt(1000000)}";
    ////print("ProductId: $productId}, SpecId:${spec.id} and GeneratedId: $_generatedId");
    final local = UserProduct(
        generatedId: _generatedId,
        productId: productId,
        hasSelected: false,
        productSpecMarketList: mapMarketList,
        productSpecDisplayName: spec.dispName ?? spec.name,
        productSpecIcon: spec.dispIcon ?? dataManager.defaultProductSpecIcon,
        productSpecId: spec.id,
        productSpecName: spec.name,
        counter: count ??
            BuySellCount(
                productId: productId,
                productSpecId: spec.id,
                totalRequestCount: 0,
                sellRequestCount: 0,
                buyRequestCount: 0));
    ////print("Added User Product in Saver: ${local.counter.totalRequestCount}");
    int result = await _productRepo.saveProductSpecToLocal(localProduct: local);

    // Update To Stream n State
    _updateActiveProduct(local);
    return result > 0 ? local : null;
  }

  Future<int> updateToLocalDatabase(UserProduct userProduct) async =>
      await _productRepo.saveProductSpecToLocal(localProduct: userProduct);

  Future<void> _onErrorDeleteDb() {
    try {} catch (e) {
      ////print("Error In Deleting Db: ${e.toString()}");
    }

    return null;
  }

  Future<void> getInitialProduct() async {
    final Map<Object, Object> _initialMap = {};
    try {
      _initialMap[ActionState] = ActionState.LOADER;
      _userProductStateDataSubject.sink.add(_initialMap);
      List<UserProduct> _upList = await _productRepo.getAllProductBarList();

      if (_upList != null && _upList.length == 0) {
        print("No data In Local Device");
        // Get Data From Server=> default api
        await getDefaultProduct();
      } else if (_upList.length > 0) {
        // Add Current Active UserProduct
        // Get Last Active Id from SharedPreferences
        final String _lastGeneratedId =
            await _productRepo.getLastActiveProductId();
        if (_lastGeneratedId != null) {
          // Checking Whether UserProductList length should not greater than maxLength
          int _maxLength = dataManager.coreSettings.maxAppbarLength;
          if (_upList.length > _maxLength) {
            // Get Last maxAppbarLength elements[0,1,2,3,4,5,6]
            final _set =
                _upList.sublist(_upList.length - _maxLength, _upList.length);
            _upList = _set;
          }
//          print("Product Length: ${_upList.length}");

          // Test
          UserProduct currentUserProduct;
          if (_upList.length == 1) {
            currentUserProduct = _upList[0];
          } else {
            _upList.forEach((UserProduct product) {
              if (product.generatedId == _lastGeneratedId) {
                currentUserProduct = product;
                return;
              }
            });
          }

//          print("Current Product Name: ${currentUserProduct.productSpecName}");

          _updateActiveProduct(currentUserProduct);
        } else {
          // Then First Element will be active
//          print("First: ${_upList.first.generatedId}");
          _updateActiveProduct(_upList.first);
        }

        /// Added total fetched local UserProduct list to Stream
        _updateUserProductListToState(_upList);
        _initialMap[ActionState] = ActionState.SUCCESS;
        _initialMap[UserProduct] = _upList;
        _userProductStateDataSubject.sink.add(_initialMap);
      } else {
        _initialMap[ActionState] = ActionState.FAILED;
        _initialMap[Failure] = Failure(
            responseStatus: "Failed",
            responseMessage: "Problem occured while retrieving");
        _userProductStateDataSubject.sink.add(_initialMap);
      }
    } catch (e) {
      print("Error Caught In ProductBloc: ${e.toString()}");
      _initialMap[ActionState] = ActionState.ERROR;
      _initialMap[Failure] =
          Failure(responseStatus: "Error", responseMessage: e.toString());
      _userProductStateDataSubject.sink.add(_initialMap);

      ////print(e.toString());
    }
    return null;
  }

  /// ******* REPOSITORY TO API_SERVER ************** ///
  ///

  Future<void> getDefaultProduct() async {
    try {
      final Map<Object, Object> _mapObject = {};
      print("Default Case Called");
      final ResponseResult _result = await _productRepo.getDefaultProduct();
      if (_result.data is Failure) {
        //print("Failed to Fetch Default Data: ${_result.data.responseMessage}");
        _mapObject[ActionState] = ActionState.FAILED;
        _mapObject[Failure] = _result.data;
        _userProductStateDataSubject.sink.add(_mapObject);
      } else if (_result.data is List) {
        /// Retrieving Data from List[Instance of 'Product', [Instance of 'ProductSpecMarket'], Instance of 'BuySellCount']
        final List<dynamic> _dataSet = _result.data;
        final Product _product = _dataSet[0];
        final List<ProductSpecMarket> _specMarketList = _dataSet[1];
        final BuySellCount _counter = _dataSet[2];
        final ProductSpec _spec = _product.productSpecs[0];

        //print("Getting TimeFrame: ${_product.productSpecs[0].timeFrame}");
        // Update To Current Active Product
        updateCurrentSelectedProduct(_product);

        // Update to UserProduct()
        // In Default Case and Prefer Case There is Only One ProductSpec, But List Of Markets
        final Map<int, List> _mapList = {};
        _specMarketList.forEach((value) {
          _mapList[value.id] = [
            value.marketHierarchy.name,
            value.marketHierarchyId
          ];
        });
        UserProduct result = await saveProductToLocal(
            productId: _product.id,
            mapMarketList: _mapList, // Getting Product_Spec_Market Ids
            spec: _spec,
            count: _counter);
        if (result != null) {
          // Update BuySell Counter
//        updateBuySellCounter(_counter);
          // Update To State
          _updateUserProductListToState([result]);
          _mapObject[ActionState] = ActionState.SUCCESS;
          // Update Graph Data
          final UserGraph _uG = UserGraph(productSpecMarket: _specMarketList);
          updateGraphData(_uG);
          _currentUserGraphSubject.sink.add(_uG);
          _userProductStateDataSubject.sink.add(_mapObject);
        }
      }
    } catch (e) {
      print("Error In fetching Default Case Product Info: ${e.toString()}");
    }
  }

  // Get All Product List
  Future<ResponseResult> getProductList({bool add = false}) async {
    final ResponseResult _reponseResult =
        await _productRepo.preferenceProductList(add);
    if (_reponseResult.data is Success) {
      dataManager.productCategoryList = _reponseResult.data.data;
      ////print(_reponseResult.data.data);
    }

    return _reponseResult;
  }

  Future<ResponseResult> getAllProductAddList() async {
    ResponseResult _resResult = await _productRepo.preferenceProductList(true);
    if (_resResult.data is Success) {
      List<ProductItem> _pItems = _resResult.data.data;
      ////print("Success");
      final firstProduct = _pItems[1];
      if (firstProduct is Product) {
        //print(firstProduct.productSpecs);

        if (firstProduct.productSpecs.length !=
            0) // Do not open the first product if there is no ProductSpecs
          dataManager.addProductDialogSpecId = firstProduct.productSpecs[0].id;
        ////print("Specid: ${dataManager.addProductDialogSpecId}");

        /// Getting First Index Id
      }
    }
    return _resResult;
  }

  // Get The Market Specification List
  Future<ResponseResult> getProductSpecMarket(int id,
      {bool isAdd = false}) async {
    _productSpecMarket.sink.add(ProductState.LOADER);
    int _selectedLength = dataManager.selectedProductSpecMarket.length;
    if (_selectedLength > 0) {
      dataManager.selectedProductSpecMarket = [];
      ////print("removed: length: ${dataManager.selectedProductSpecMarket.length}");
    }

    final ResponseResult _reponseResult =
        await _productRepo.getProductSpecMarkets(id, isAdd: isAdd);

    if (_reponseResult.data is Success) {
      dataManager.productSpecMarketL = _reponseResult.data.data;
      _productSpecMarket.sink.add(ProductState.SUCCESS);

      ////print(_reponseResult.data.data);
    } else if (_reponseResult.data is Failure) {
      _productSpecMarket.sink.add(ProductState.FAILED);
    }

    return _reponseResult;
  }

  // changeDeafultTimeframe
  // Update Default TIme Frame To User Tapped TimeFrame
  void changeDefaultTimeFrame(TimeFrame timeFrame) {
    try {
      final currentProduct = _currentProductSubject.stream.value;
      final ProductSpec _spec = currentProduct.productSpecs[0];
      _spec.defaultTimeFrame = timeFrame;
      currentProduct.productSpecs[0] = _spec;
      _currentProductSubject.sink.add(currentProduct);
    } catch (e) {
      //print('Error In Changing Time Frame: $e');
    }
  }
}
