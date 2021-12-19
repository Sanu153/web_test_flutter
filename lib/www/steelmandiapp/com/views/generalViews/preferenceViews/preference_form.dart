//import 'package:flutter/material.dart';
//
//class MyPreferenceForm extends StatefulWidget {
//  @override
//  _MyPreferenceFormState createState() => _MyPreferenceFormState();
//}
//
//class _MyPreferenceFormState extends State<MyPreferenceForm> {
//
//
//
//  Widget _buildProduct() {
//    final title = Theme.of(context).textTheme.subtitle;
//
//    return ListTile(
//      title: Text(
//        "Product",
//        style: title,
//      ),
//      subtitle: DropdownButtonFormField<PreferProduct>(
//        value: null,
//        decoration: InputDecoration(
//          counterText: "Products",
//        ),
//        onChanged: (PreferProduct product) {
//          setState(() {
////              _preferProduct = null;
//            _preferProduct = product;
//            productName = product.productName;
//          });
//        },
//        hint: Text(
//          "${productName}",
//          style: Theme.of(context).textTheme.subhead,
//        ),
//        items: _filterProductList
//            .map<DropdownMenuItem<PreferProduct>>((PreferProduct value) {
//          //print(value.productName);
//          productName = _filterProductList[0].productName;
//
//          return DropdownMenuItem<PreferProduct>(
//            value: value,
//            child: Text(value.productName),
//          );
//        }).toList(),
//      ),
//    );
//  }
//
//  Widget _buildMarketType() {
//    final title = Theme.of(context).textTheme.subtitle;
//
//    return ListTile(
//      title: Text(
//        "Market Category",
//        style: title,
//      ),
//      subtitle: DropdownButtonFormField<PreferProduct>(
//        value: null,
//        decoration: InputDecoration(
//          counterText: "Products",
//        ),
//        onChanged: (PreferProduct product) {
//          setState(() {
////              _preferProduct = null;
//            _preferProduct = product;
//            productName = product.productName;
//          });
//        },
//        hint: Text(
//          "${productName}",
//          style: Theme.of(context).textTheme.subhead,
//        ),
//        items: _filterProductList
//            .map<DropdownMenuItem<PreferProduct>>((PreferProduct value) {
//          //print(value.productName);
//          productName = _filterProductList[0].productName;
//
//          return DropdownMenuItem<PreferProduct>(
//            value: value,
//            child: Text(value.productName),
//          );
//        }).toList(),
//      ),
//    );
//  }
//
//  Widget _buildMarket() {
//    final title = Theme.of(context).textTheme.subtitle;
//
//    return ListTile(
//      title: Text(
//        "Market",
//        style: title,
//      ),
//      subtitle: DropdownButtonFormField<PreferProduct>(
//        value: null,
//        decoration: InputDecoration(
//          counterText: "Products",
//        ),
//        onChanged: (PreferProduct product) {
//          setState(() {
////              _preferProduct = null;
//            _preferProduct = product;
//            productName = product.productName;
//          });
//        },
//        hint: Text(
//          "${productName}",
//          style: Theme.of(context).textTheme.subhead,
//        ),
//        items: _filterProductList
//            .map<DropdownMenuItem<PreferProduct>>((PreferProduct value) {
//          //print(value.productName);
//          productName = _filterProductList[0].productName;
//
//          return DropdownMenuItem<PreferProduct>(
//            value: value,
//            child: Text(value.productName),
//          );
//        }).toList(),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView(
////                mainAxisAlignment: MainAxisAlignment.start,
//      children: <Widget>[
//
//        _buildMarketType(),
//        _buildProduct(),
//        _buildMarket(),
//      ],
//    );
//  }
//}
