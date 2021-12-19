import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/configs/system_config.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/generalViews/preferenceViews/preference_screens.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final double minValue = 8.0;

  void _makeOrientation() async {
    await SystemConfig.makeDevicePotrait();
  }

  void _onPreference() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyprefernceScreen()));
  }

  @override
  void dispose() {
    SystemConfig.makeDeviceLandscape();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
//    print("Did Change Depe");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
//    print("didUpdateWidget");
    _makeOrientation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: minValue),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Preferences"),
              subtitle: Text("Go to preference"),
              onTap: () => _onPreference(),
            )
          ],
        ),
      ),
    );
  }
}
