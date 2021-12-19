import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<OrdinalSales> chartData;
  List<CartesianChartAnnotation> chartAnnotation = [];
  Color annotationColor = Colors.lightBlue;
  String annotationText = 'Text';
  int count = 0;

  @override
  void initState() {
    chartData = <OrdinalSales>[
      OrdinalSales(0, 0),
    ];
    addAnnotation();
    super.initState();
  }

  Timer timer;

  @override
  void dispose() {
    super.dispose();
  }

  void addAnnotation() {
    //print("Anotation Called");
    count += 1;
    if (count > 15) {
      chartAnnotation = [];
      count = 0;
    }
    setState(() {
      chartAnnotation.add(CartesianChartAnnotation(
          widget: Container(
              child: Container(
                  height: 4 + count.toDouble(),
                  width: 4 + count.toDouble(),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(getRandomInt(10, 200),
                        getRandomInt(1, 230), getRandomInt(10, 200), 1),
                  ),
                  child: Text(annotationText + count.toString()))),
          coordinateUnit: CoordinateUnit.point,
          region: AnnotationRegion.chart,
          x: 4,
          y: 25));
    });
  }

  List<CartesianChartAnnotation> get annotation {
    //print("Length: ${chartAnnotation.length}");
    return chartAnnotation;
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000), () {
      addAnnotation();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),
      body: Container(
          child: SfCartesianChart(
        annotations: annotation,
        zoomPanBehavior: ZoomPanBehavior(
//            enableDoubleTapZooming: true,
            enableSelectionZooming: true,
//            enablePinching: true,
//            zoomMode: ZoomMode.x,
            enablePanning: true),
        primaryXAxis: NumericAxis(visibleMaximum: 6, visibleMinimum: 2),
        primaryYAxis: NumericAxis(opposedPosition: true),
        series: <AreaSeries<OrdinalSales, int>>[
          AreaSeries<OrdinalSales, int>(
            dataSource: [
              OrdinalSales(1, 23),
              OrdinalSales(2, 45),
              OrdinalSales(3, 35),
              OrdinalSales(4, 62),
              OrdinalSales(5, 38),
              OrdinalSales(6, 27),
              OrdinalSales(7, 16),
              OrdinalSales(8, 27),
              OrdinalSales(9, 39),
              OrdinalSales(10, 32),
              OrdinalSales(11, 39),
              OrdinalSales(12, 42),
              OrdinalSales(13, 39),
              OrdinalSales(14, 42),
            ],
            color: const Color.fromRGBO(255, 0, 102, 1),
            xValueMapper: (OrdinalSales sales, _) => sales.country,
            yValueMapper: (OrdinalSales sales, _) => sales.sales,
            animationDuration: 0,
          )
        ],
      )),
    );
  }

  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  List<OrdinalSales> getChartData() {
    chartData.add(OrdinalSales(count, getRandomInt(10, 100)));

    chartData = <OrdinalSales>[
      OrdinalSales(1, getRandomInt(10, 100)),
      OrdinalSales(2, getRandomInt(10, 100)),
      OrdinalSales(3, getRandomInt(10, 100)),
      OrdinalSales(4, getRandomInt(10, 100)),
      OrdinalSales(5, getRandomInt(10, 100)),
      OrdinalSales(6, getRandomInt(10, 100)),
      OrdinalSales(7, getRandomInt(10, 100)),
      OrdinalSales(8, getRandomInt(10, 100)),
      OrdinalSales(9, getRandomInt(10, 100)),
      OrdinalSales(10, getRandomInt(10, 100)),
    ];

    return chartData;
  }
}

class OrdinalSales {
  OrdinalSales(this.country, this.sales);

  final num country;
  final int sales;
}
