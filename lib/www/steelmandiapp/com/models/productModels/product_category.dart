import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';

class ProductCategory {
  int id;
  String productTypeName;
  List<Product> products;

  ProductCategory({this.id, this.productTypeName, this.products});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productTypeName = json['product_type_name'];
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_type_name'] = this.productTypeName;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
