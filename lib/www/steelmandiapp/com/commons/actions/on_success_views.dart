import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/themes/colors.dart';

class MyResponseSuccess extends StatelessWidget {
  double minValue = 8.0;

  final String title;
  final String subtitle;
  final String data;

  MyResponseSuccess({this.title = '', this.subtitle = '', this.data = ''});

  Widget _buildAnimated() {
    return SpinKitRipple(
      itemBuilder: (BuildContext context, int index) {
        return CircleAvatar(
          child: Icon(
            Icons.done,
            size: 35,
            color: Colors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme.title.apply(color: Colors.white);
    final sub = Theme.of(context).textTheme.subhead.apply(color: Colors.white);
    final emailStyel = TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: Card(
        color: greenColor,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(minValue),
        child: Padding(
          padding: EdgeInsets.all(minValue * 2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$title",
                      style: t,
                    ),
                    Text(
                      '$data',
                      style: emailStyel,
                    ),
                    Text(
                      '$subtitle',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              _buildAnimated()
            ],
          ),
        ),
      ),
    );
  }
}
