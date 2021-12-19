import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/announceBloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/announcements/events_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/announcements/news_list.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/announcements/tenders_list.dart';

class MyAnnouncementViews extends StatelessWidget {
  final double minValue = 8.0;
  TabController controller;
  int tabBarIndex = 0;

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
            "Announcements",
            style: t.apply(color: Colors.white),
          ),
          Row(
            children: <Widget>[
              Text(
                "All",
                style: sub.apply(color: Colors.white60),
              ),
              SizedBox(
                width: minValue,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white70,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody() {
    return Container(
      height: kToolbarHeight,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        unselectedLabelColor: Colors.white70,
        indicatorColor: Colors.white54,
        tabs: [
          Tab(
            child: Text("NEWS"),
          ),
          Tab(
            child: Text("TENDERS"),
          ),
          Tab(
            child: Text("EVENTS"),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final AnnouncementBloc _annoucement =
        Provider.of(context).fetch(AnnouncementBloc);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCustomLeading(context),
            _buildTabBody(),
            Expanded(
              child: TabBarView(
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  MyNewsViews(
                    bloc: _annoucement,
                  ),
                  MyTenderList(
                    bloc: _annoucement,
                  ),
                  MyEventList(
                    bloc: _annoucement,
                  )
                ],
//                children: [Container(), Container(), Container()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  void listener() {
    //print("Listening");
    //print(controller.index);
  }
}
