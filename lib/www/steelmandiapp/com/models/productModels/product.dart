import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_sepeartor.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';

class Product implements ProductItem {
  int id;
  String productName;
  int productTypeId;
  String icon;
  List<ProductSpec> productSpecs;

  Product ({this.id,
    this.productName,
    this.productTypeId,
    this.icon,
    this.productSpecs});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productTypeId = json['product_type_id'];
    icon = json['icon'];
    if (json['product_specs'] != null) {
      productSpecs = new List<ProductSpec>();
      json['product_specs'].forEach((v) {
        productSpecs.add(new ProductSpec.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_type_id'] = this.productTypeId;
    data['icon'] = this.icon;
    if (this.productSpecs != null) {
      data['product_specs'] = this.productSpecs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
