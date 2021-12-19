import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/portfolio/closed_requests.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/portfolio/opened_list.dart';

class MyPortfolioViews extends StatelessWidget {
  final double minValue = 8.0;

  Widget _buildCustomLeading(BuildContext context) {
    final t = Theme.of(context).textTheme.title;
    final sub = Theme.of(context).textTheme.subtitle;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Portfolio",
            style: t.apply(color: Colors.white),
          ),
          Text(
            "All assets",
            style: sub.apply(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(BuildContext context) {
    final PortfolioBloc portfolioBloc =
        Provider.of(context).fetch(PortfolioBloc);

    return Container(
      height: 40,
      child: TabBar(
        isScrollable: false,
        unselectedLabelColor: Colors.white70,
//        indicatorPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.white54,
//        indicator: BoxDecoration(
//            color: Color(0xff203557), borderRadius: BorderRadius.circular(5.0)),
        tabs: [
          StreamBuilder<int>(
              initialData: 0,
              stream: portfolioBloc.portfolioOpenedCounter$,
              builder: (context, snapshot) {
                return _buildTabs(context,
                    color: greenColor, title: "OPEN", request: snapshot.data);
              }),
          StreamBuilder<int>(
              initialData: 0,
              stream: portfolioBloc.portfolioClosedCounter$,
              builder: (context, snapshot) {
                return _buildTabs(context,
                    color: greenColor, title: "CLOSED", request: snapshot.data);
              }),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context,
      {String title, int request, Color color}) {
    final t = Theme.of(context).textTheme.caption;
    final sub = Theme.of(context).textTheme.subtitle;
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$title",
          style: t.apply(color: Colors.white, fontWeightDelta: 1),
        ),
        Text(
          "($request)",
          style: t.apply(color: Colors.white70),
        ),
      ],
    ));
  }

  Widget _buildErrorBody(Failure failed, int postion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        _buildCustomLeading(),
//        _buildTabBody(),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              ResponseFailure(
                title: failed.responseMessage,
              ),
              ResponseFailure(
                title: failed.responseMessage,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioBloc portfolioBloc =
        Provider.of(context).fetch(PortfolioBloc);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCustomLeading(context),
              _buildTabBody(context),
              Expanded(
                child: TabBarView(
                  children: [
                    MyOpenedList(
                      portfolioBloc: portfolioBloc,
                    ),
                    MyClosedRequests(
                      portfolioBloc: portfolioBloc,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
