import 'package:flutter/material.dart';

class MarketSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text("Search Results"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Text("Search Suggestions"),
    );
  }
}
