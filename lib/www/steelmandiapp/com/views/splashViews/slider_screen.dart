import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/core_settings.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/SplashSlider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/splashViews/bottom_bar.dart';

class SliderScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SliderScreen> {
  PageController _pageController;
  int _currentIndex = 0;
  final double _minPadding = 8.0;

  @override
  initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    //    Display  Status Bar
//    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  List<Widget> pages = [
    MySplashSliderComponents(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          "assets/image/SM_logo.png",
          fit: BoxFit.contain,
          width: 250,
        ),
      ),
      title: "Welcome to ${CoreSettings.appName}",
      subtitle: "Swipe to learn more",
    ),
    MySplashSliderComponents(
      icon: Icons.shopping_basket,
      title: "Easy Trading",
      subtitle: "Trade steel products with ease and confidence",
    ),
    MySplashSliderComponents(
      icon: Icons.security,
      title: "Account Security",
      subtitle: "At the end, the goals are similar: safety and security",
    ),
    MySplashSliderComponents(
      icon: Icons.help,
      title: "24/7 Support",
      subtitle:
      "Our trained support team is happy to help 24/7 in chats, messages and calls",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Container(child: _buildSplashBody(context))));
  }

  Widget _buildSplashBody(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        child: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: pages,
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: MyBottomBar(),
      ),
    ]);
  }

  void onPageChanged(int value) {}
}
