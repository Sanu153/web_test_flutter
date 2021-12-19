import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/graphBloc/graph_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/user_graph_model.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/user_product_spec.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/graphViews/area_chart_graph.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/graphViews/test/line_series_init.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/stream_mania.dart';

class MyMainGraphViews extends StatefulWidget {
  final List<UserProduct> userProductList;

  MyMainGraphViews({@required this.userProductList});

  @override
  _MyMainGraphViewsState createState() => _MyMainGraphViewsState();
}

class _MyMainGraphViewsState extends State<MyMainGraphViews> {
  final double minValue = 8.0;

  GraphBloc graphBloc;

  Widget _buildProductListInfo(BuildContext context) {
    return Container(
      height: 70.0,
//      color: Colors.white10,
    );
  }

  @override
  void initState() {
    super.initState();

    ////print("Maingraph Init State");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemConfig.makeStatusBarHide();

    ////print("Maingraph didChangeDependencies State 9999999999999999999999999999999999999999");
    graphBloc = Provider.of(context).fetch(GraphBloc);
    graphBloc.getProductSpecMarketGraph();
  }

  @override
  Widget build(BuildContext context) {
    final ProductBloc productBloc = Provider.of(context).fetch(ProductBloc);

    return Container(
      padding: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            graphBackground1,
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColor,
          ])),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
//          DateTimeZooming()
//          CandleChart(),
//          LiveUpdateHorizontalData()
//          MyAreaChartDemo(),
//          TestOne(),
          StreamMania<UserGraph>(
              stream: graphBloc.getUserGraph$,
              onWaiting: (context) {
                //print("Graph Waiting For Data");
                return MyComponentsLoader();
              },
              onFailed: (context, Failure failed) {
                return ResponseFailure(
                  title: failed.responseMessage,
                );
              },
              onError: (context, Failure failed) {
                return ResponseFailure(
                  title: failed.responseMessage,
                  subtitle: "Please check your internet settings",
                );
              },
              onSuccess: (context, UserGraph graph) {
                if (graph == null) return Container();
                final GraphSettings settings = graph.settings;
                if (settings.chartType == ChartType.LINE_CHART) {
                  return MyLineSeriesInitGraph(
                    graph: graph,
                  );
                } else if (settings.chartType == ChartType.CANDLESTICK) {
                  return Container();
                } else if (settings.chartType == ChartType.AREA_CHART) {
//                  return AreaDefault();

                  return AreaChartGraph(
                    graph: graph,
                  );
                } else {
                  return MyLineSeriesInitGraph(
                    graph: graph,
                  );
                }
              }),

//              _buildProductListInfo(context),

//
        ],
      ),
    );
  }
}
