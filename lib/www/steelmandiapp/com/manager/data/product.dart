import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_category.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';

class SharedProductData {
  /// It will store the total productCategory List => from Server
  List<ProductCategory> productCategoryList;

  /// This will be assigned when the product id wiil be selected
  List<ProductSpecMarket> productSpecMarketL;

  /// This is the ProductSpec in which an user will be interacted
  UserProduct userProductSpec;
  List<UserProduct> userProductSpecL;
  String defaultProductSpecIcon =
      "https://cdn.pixabay.com/photo/2019/11/17/00/24/ring-key-4631368__340.jpg";

  int addProductDialogSpecId;

  // Adder Dialog
  ProductSpec selectedProductSpec;
  int selectedProductId;

//  String defaultProductSpecIcon =
//      "https://image.shutterstock.com/image-vector/green-metal-texture-background-vector-260nw-754834261.jpg";
}
