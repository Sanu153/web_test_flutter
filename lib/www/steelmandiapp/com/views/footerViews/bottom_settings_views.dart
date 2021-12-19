import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/productBloc/product_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/widgets/feature_implement_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/settingsViews/footer/chart_footer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/marketViews/buySellAlertViews/buy_seel_alert_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/productViews/info/info_views.dart';

class MyBottomIconSettings extends StatefulWidget {
  @override
  _MyBottomIconSettingsState createState() => _MyBottomIconSettingsState();
}

class _MyBottomIconSettingsState extends State<MyBottomIconSettings> {
  ProductBloc _productBloc;
  MarketBloc _marketBloc;

  final Color color = Colors.white70;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _productBloc = Provider.of(context).fetch(ProductBloc);
    _marketBloc = Provider.of(context).fetch(MarketBloc);
  }

  void onIconButtonTap(Footer footer, int index) {
    setState(() {
      _currentIndex = index;
    });
    if (footer == Footer.GRAPH) {
      DialogHandler.footerBarDialog(
              context: context, child: MyFooterChartSettings())
          .then((dynamic d) {
        //print("Dialog Then: $d");
        if (!mounted) return;

        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (footer == Footer.NOTIFICATIONS) {
      DialogHandler.confirmBuySellDialog(
              context: context, isBar: true, child: MyAlertViews())
          .then((dynamic d) {
        if (!mounted) return;

        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (footer == Footer.INFO) {
      DialogHandler.showMyBottomSidebarDialog(
          context: context,
          child: Container(
            child: MyProductInfoViews(marketBloc: _marketBloc),
          )).then((value) {
        if (!mounted) return;
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (footer == Footer.SETTINGS) {
      DialogHandler.footerBarDialog(
              context: context, child: Container(child: FeatureImplement()))
          .then((dynamic d) {
        //print("Dialog Then: $d");
        if (!mounted) return;
        setState(() {
          _currentIndex = 0;
        });
      });
    }
  }

  Widget _buildIconButton(Icon icon, bool active, Function onPressed) {
    return Material(
      color: active ? Colors.blueGrey[800] : Colors.transparent,
      child: IconButton(
          iconSize: 14, color: color, icon: icon, onPressed: onPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210.0,
//      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildIconButton(
            Icon(
              Icons.info,
            ),
            _currentIndex == 1,
            () => onIconButtonTap(Footer.INFO, 1),
          ),
          _buildIconButton(Icon(Icons.notifications), _currentIndex == 2,
              () => onIconButtonTap(Footer.NOTIFICATIONS, 2)),
          _buildIconButton(Icon(Icons.build), _currentIndex == 3,
              () => onIconButtonTap(Footer.SETTINGS, 3)),
          _buildIconButton(Icon(Icons.show_chart), _currentIndex == 4,
              () => onIconButtonTap(Footer.GRAPH, 4)),
        ],
      ),
    );
  }
}
