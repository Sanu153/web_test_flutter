import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/sidebar_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/actions/sidebar_icon_button.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/new_notifier.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/data_manager.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/announcements/announcement_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/more_side_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/portfolio/portfolio_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/supportChartViews/support_chat_views.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/tradeBookViews/trade_book_screen.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/sidebarViews/sidebar_widget.dart';

class MySidebarScreen extends StatefulWidget {
  final Function onTapped;

  MySidebarScreen({@required this.onTapped});

  @override
  _MySidebAState createState() => _MySidebAState();
}

class _MySidebAState extends State<MySidebarScreen> {
  SideBarBloc sideBarBloc;
  PortfolioBloc _portfolioBloc;

  int _currentIndex = -1;
  bool isSelected = false;

  double padding = 8.0;

  final double iconSize = CoreSettings.iconSize;

  final Color activeColor = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sideBarBloc = Provider.of(context).fetch(SideBarBloc);
    _portfolioBloc = Provider.of(context).fetch(PortfolioBloc);
  }

  void _openDialog(int index, Widget item,
      {bool isFromMoreSection = false}) async {
    // Reset to Default Sidebar icon
    sideBarBloc.resetIcon();
    setState(() {
      _currentIndex = index;
    });
//    print("Current Index: $_currentIndex");
    DialogHandler.openMySideBarDialog(context: context, child: item)
        .then((value) {
      if (mounted) {
        setState(() {
          _currentIndex = -1;
        });
      }
      if (index == 1) {
        _portfolioBloc.makeInitial();
      }
    });

//    print("Current Index End: $_currentIndex");
  }

  void _moreIconTap() {
    DialogHandler.openDialogWithSidebar(
        context: context,
        child: SideBarWidget(
          hasMore: true,
          child: MyCustomizeViews(
            onTap: _onMoreIconItemTap,
            activeIndex: 5,
            onDrawerMenu: () {
              Navigator.of(context).pop();
              _openDrawer();
            },
          ),
        ));
  }

  void _onMoreIconItemTap(int index) {
    if (!mounted) return;

    // Closing More Dialog
    Navigator.of(context).pop();

    Widget _widget;
    if (index == 1) {
      _widget = MyPortfolioViews();
    } else if (index == 2) {
      _widget = TradeBookScreen();
    } else if (index == 3) {
      _widget = MyAnnouncementViews();
    } else if (index == 4) {
      _widget = MySupportViews();
    } else {
      // Closed More Action Dialog
//      Navigator.of(context).pop();
      return;
    }
//    print("Index: $index");
    _openDialog(index, _widget);
  }

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  List<Widget> _buildChildren() {
    return [
      Material(
        color: Colors.transparent,
        child: IconButton(
            iconSize: iconSize,
            color: iconColor,
            icon: Icon(
              Icons.menu,
            ),
            onPressed: () {
              _openDrawer();
            }),
      ),
      StreamBuilder<int>(
          initialData: 0,
          stream: _portfolioBloc.portfolioUnseenRequestCounter$,
          builder: (context, snapshot) {
//            print("Portfolio Counter Update Data: ${snapshot.data}");
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                MySideBarIconButton(
                  icon: Icons.work,
                  isSelected: _currentIndex == 1,
                  onIconTap: () => _openDialog(1, MyPortfolioViews()),
                ),
                snapshot.data != 0
                    ? MyNotifyShape(
                        color: greenColor,
//                        counter: snapshot.data,
//                        shape: BoxShape.rectangle,
                      )
                    : Container()
              ],
            );
          }),
      MySideBarIconButton(
        icon: Icons.assessment,
        isSelected: _currentIndex == 2,
        onIconTap: () => _openDialog(2, TradeBookScreen()),
      ),
      MySideBarIconButton(
        icon: Icons.surround_sound,
        isSelected: _currentIndex == 3,
        onIconTap: () => _openDialog(3, MyAnnouncementViews()),
      ),
      MySideBarIconButton(
        icon: Icons.chat,
        isSelected: _currentIndex == 4,
        onIconTap: () => _openDialog(4, MySupportViews()),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: MySideBarIconButton(
            icon: Icons.more_horiz,
            isSelected: _currentIndex == 5,
            onIconTap: () => _moreIconTap(),
          ))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final DataManager settings = Provider.of(context).dataManager;
//    //print("UPdated Sidebar Width =  ${settings.coreSettings.sideBarWidth}");
    final or = MediaQuery.of(context).orientation;

    return or == Orientation.portrait
        ? Container()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
            final layoutHeight = boxConstraints.biggest.height;
            final fullHeight = MediaQuery.of(context).size.height;
            if (layoutHeight < fullHeight) {
              return Container(
                  height: layoutHeight,
                  width: settings.coreSettings.sideBarWidth,
                  child: ListView(
                    children: _buildChildren(),
                  ));
            }
            return Container(
              width: settings.coreSettings.sideBarWidth,
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).primaryColor,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _buildChildren()),
            );
          });
  }

  void onSideBarIconTap(int currentIndex) {
    //print("Current Index $currentIndex");
    setState(() {
      _currentIndex = currentIndex;
    });
//    neverSatisfied(context);
  }
}
