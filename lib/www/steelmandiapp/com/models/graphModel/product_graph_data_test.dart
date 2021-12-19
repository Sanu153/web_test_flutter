import 'dart:math';

class ProductGraphData {
  double x, y;

  ProductGraphData({this.x, this.y});
}

class ProductComparison {
  double x, y1, y2;

  ProductComparison({this.x, this.y1, this.y2});
}

getColumnData() {
  return <ProductGraphData>[
    ProductGraphData(x: 10, y: 20),
    ProductGraphData(x: 20, y: 30),
    ProductGraphData(x: 30, y: 10),
    ProductGraphData(x: 40, y: 40),
    ProductGraphData(x: 50, y: 60),
    ProductGraphData(x: 60, y: 45)
  ];
}

dynamic getLargeDataSets() {
  List<ProductGraphData> _huge = <ProductGraphData>[];
  double value = 10;

  Random rand = Random();
  for (int i = 0; i < 100; i++) {
    if (rand.nextDouble() > 0.5) {
      value += rand.nextDouble();
    } else {
      value -= rand.nextDouble();
    }
    _huge.add(ProductGraphData(x: i.toDouble(), y: value));
  }
  //print("Data Length: ${_huge.length}");
  return _huge;
}

dynamic getLargeComparisonData() {
  List<ProductComparison> _huge = <ProductComparison>[];
  List testData = [];
  double value = 10;
  double y2Value = 20;

  Random rand = Random();
  for (int i = 0; i < 500; i++) {
    if (rand.nextDouble() > 0.5) {
      value += rand.nextDouble();
      y2Value += rand.nextDouble();
    } else {
      value -= rand.nextDouble();
      y2Value -= rand.nextDouble();
    }
    _huge.add(
        ProductComparison(x: i.toDouble() + value, y1: value, y2: y2Value));
    testData.add([i + value, value, y2Value]);
  }
  //print("Data Length: ${testData.length}");
//  //print("Data Sets: $testData");

  return _huge;
}

int j = 0;
List<ProductGraphData> liveData = <ProductGraphData>[];

dynamic getLiveData() {
  j++;
  double value = 100;

  Random rand = Random();
  if (rand.nextDouble() > 0.5) {
    value += rand.nextDouble();
  } else {
    value -= rand.nextDouble();
  }

  if (j > 50) {
    liveData.removeAt(0);
  }

  liveData.add(ProductGraphData(x: j.toDouble(), y: value));
}

class DateTimeData {
  DateTimeData(this.year, this.y);

  final DateTime year;
  final double y;
}

dynamic getDatatTimeData() {
  final List<DateTimeData> randomData = <DateTimeData>[];
  final Random rand = Random();
  double value = 100;
  for (int i = 1; i < 500; i++) {
    if (rand.nextDouble() > 0.5)
      value += rand.nextDouble();
    else
      value -= rand.nextDouble();

    randomData.add(DateTimeData(DateTime(1900, i, 1), value));
  }
  return randomData;
}

dynamic getDatatTimeDataSecond() {
  final List<DateTimeData> randomData = <DateTimeData>[];
  final Random rand = Random();
  double value = 50;
  for (int i = 1; i < 500; i++) {
    if (rand.nextDouble() > 0.5)
      value += rand.nextDouble();
    else
      value -= rand.nextDouble();

    randomData.add(DateTimeData(DateTime(1900, i, 1), value));
  }
  return randomData;
}
