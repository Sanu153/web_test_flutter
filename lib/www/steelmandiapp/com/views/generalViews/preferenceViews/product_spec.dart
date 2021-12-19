import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec.dart';

class MyProductSpecList extends StatelessWidget {
  final double minValue = 8.0;

  final Function onChanged;
  final Product product;

  MyProductSpecList({@required this.onChanged, this.product});

  @override
  Widget build(BuildContext context) {
    //print("Product: $product");
    return Container(
      width: double.maxFinite,
      child: product == null || product.productSpecs.length == 0
          ? ResponseFailure(
              subtitle: product == null
                  ? "Please choose products"
                  : "No product specifications found for ${product.productName}",
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: product.productSpecs.length,
              itemBuilder: (context, int index) {
                ProductSpec _spec = product.productSpecs[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: minValue * 1.3,
                    backgroundImage: _spec.dispIcon == null
                        ? null
                        : NetworkImage(_spec.dispIcon),
                    child: _spec.dispIcon == null
                        ? Icon(
                            Icons.category,
                            size: minValue * 2,
                          )
                        : null,
                  ),
                  onTap: () => onChanged(_spec),
                  title: Text("${_spec.name}"),
                  subtitle: Text(" ${_spec.dispName ?? 'Specification'}"),
                );
              }),
    );
  }
}
