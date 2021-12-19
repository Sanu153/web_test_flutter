import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class ResponseFailure extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hasImageDisplay;
  final bool hasDark;
  final VoidCallback reload;

  ResponseFailure(
      {this.title,
      this.subtitle,
      this.hasImageDisplay = false,
      this.reload,
      this.hasDark = false});

  final String assetName = 'assets/image/moon_error.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hasImageDisplay
              ? Image.asset(
                  assetName,
                  width: 250.0,
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          Text(
            "${title ?? 'Not Found'}",
            style: Theme.of(context)
                .textTheme
                .title
                .apply(color: hasDark ? Colors.white70 : Colors.blueGrey[800]),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${subtitle ?? 'Data not available'}",
            style: Theme.of(context)
                .textTheme
                .caption
                .apply(color: Colors.blueGrey),
          ),
          SizedBox(
            height: 10,
          ),
          reload == null
              ? Container()
              : MaterialButton(
                  onPressed: reload,
                  child: Text("Reload"),
                  color: chatTileOne,
                  textColor: Colors.white70,
                )
        ],
      ),
    );
  }
}
