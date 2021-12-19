import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/schedule.dart';

class ScheduleBuilder extends StatelessWidget {
  final List<Schedule> schedules;
  final Function builder;

  const ScheduleBuilder({Key key, this.schedules, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: builder,
      itemCount: schedules.length,
      padding: EdgeInsets.symmetric(vertical: 8.0 * 2),
    );
  }
}
