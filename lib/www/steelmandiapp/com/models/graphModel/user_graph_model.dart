import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/graphModel/annotation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/product_spec_market.dart';

class UserGraph {
  List<ProductSpecMarket> productSpecMarket;
  GraphSettings settings;
  List<Annotation> annotations;

  UserGraph({this.settings, this.productSpecMarket, this.annotations});
}

class GraphSettings {
  ChartType chartType;
  int timeFrame;
  bool toolTip;
  bool trackBal;
  bool crossHair;
  bool showLiveDeals;
  bool showLabel;

  GraphSettings(
      {this.timeFrame,
      this.chartType = ChartType.AREA_CHART,
      this.toolTip = false,
      this.trackBal = false,
      this.crossHair = false,
      this.showLiveDeals,
      this.showLabel});
}
