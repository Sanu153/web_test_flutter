import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_category.dart';

class MyProductTypeList extends StatelessWidget {
  final double minValue = 8.0;

  final Function onChanged;

  MyProductTypeList({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final productTypeList =
        Provider.of(context).dataManager.productCategoryList;

    return Container(
      width: double.maxFinite,
      child: productTypeList == null || productTypeList.length == 0
          ? ResponseFailure(
              subtitle: "No product category available",
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: productTypeList.length,
              itemBuilder: (context, int index) {
                ProductCategory _category = productTypeList[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: minValue * 1.3,
                    child: Icon(
                      Icons.category,
                      size: minValue * 2,
                    ),
                  ),
                  onTap: () => onChanged(_category),
                  title: Text("${_category.productTypeName}"),
                  subtitle:
                  Text("Available Products(${_category.products.length})"),
                );
              }),
    );
  }
}
