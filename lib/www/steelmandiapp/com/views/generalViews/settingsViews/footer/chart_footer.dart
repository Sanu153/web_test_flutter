import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/feature_implement_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/user_graph_model.dart';

class MyFooterChartSettings extends StatelessWidget {
  final double minValue = 8.00;
  final Color color = Colors.white60;

  Widget _buildChrtType({IconData iconName, Function onTap}) {
    return IconButton(
      icon: Icon(iconName),
      onPressed: onTap,
      color: color,
      iconSize: 19,
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle =
        Theme.of(context).textTheme.caption.apply(fontWeightDelta: 1);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding:
            EdgeInsets.only(right: minValue, left: minValue, top: minValue),
        child: StreamBuilder<UserGraph>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "CHART SETTINGS",
                    style: TextStyle(
                        color: color,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: minValue),
                    color: secondaryColor,
                    height: 40.0,
                    child: Material(
                      color: Colors.transparent,
                      child: ListView(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          _buildChrtType(
                              iconName: Icons.multiline_chart,
                              onTap: () {
                                //print("Ona");
                              }),
                          _buildChrtType(
                              iconName: Icons.insert_chart,
                              onTap: () {
                                //print("Ona[");
                              }),
                          _buildChrtType(
                              iconName: Icons.show_chart,
                              onTap: () {
                                //print("Ona[");
                              }),
                          _buildChrtType(
                              iconName: Icons.table_chart,
                              onTap: () {
                                //print("Ona[");
                              }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: FeatureImplement(),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
