import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_category.dart';

class MyProductList extends StatelessWidget {
  final double minValue = 8.0;

  final Function onChanged;
  final ProductCategory category;

  MyProductList({@required this.onChanged, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: category == null || category.products.length == 0
          ? ResponseFailure(
              subtitle: category == null
                  ? "Please choose a product category"
                  : "No products found for ${category.productTypeName}",
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: category.products.length,
              itemBuilder: (context, int index) {
                Product _product = category.products[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: minValue * 1.3,
                    backgroundImage: _product.icon == null
                        ? null
                        : NetworkImage(_product.icon),
                    child: _product.icon == null
                        ? Icon(
                            Icons.category,
                            size: minValue * 2,
                          )
                        : null,
                  ),
                  onTap: () => onChanged(_product),
                  title: Text("${_product.productName}"),
                  subtitle:
                  Text("Product Specs(${_product.productSpecs.length})"),
                );
              }),
    );
  }
}
