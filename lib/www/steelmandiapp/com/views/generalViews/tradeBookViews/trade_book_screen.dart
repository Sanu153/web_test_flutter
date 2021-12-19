import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/contract/trade_book_contract_list_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/schedule/trade_book_schedule_screen.dart';

class TradeBookScreen extends StatelessWidget {
  final double minValue = 8.0;

  Widget _buildCustomLeading(BuildContext context) {
    final t = Theme.of(context).textTheme.headline6;
    final sub = Theme.of(context).textTheme.subtitle1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Trade Book",
            style: t.apply(color: Colors.white),
          ),
//          Text(
//            "All",
//            style: sub.apply(color: Colors.white60),
//          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(BuildContext context) {
    return Container(
      height: 40,
      child: TabBar(
        isScrollable: false,
        unselectedLabelColor: Colors.white70,
//        labelPadding: EdgeInsets.all(2),
//        indicatorPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.white54,
//        indicator: BoxDecoration(
//            color: Color(0xff203557), borderRadius: BorderRadius.circular(5.0)),
        tabs: [
          Tab(
            text: "Schedule",
          ),
          Tab(
            text: "Contract",
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MarketBloc _marketBloc = Provider.of(context).fetch(MarketBloc);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCustomLeading(context),
                SizedBox(
                  height: 8,
                ),
                _buildTabBody(context),
                Expanded(
                  child: TabBarView(
                    children: [
                      ScheduleTradeBookScreen(
                        marketBloc: _marketBloc,
                      ),
                      ContractTradebookScreen(
                        marketBloc: _marketBloc,
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
