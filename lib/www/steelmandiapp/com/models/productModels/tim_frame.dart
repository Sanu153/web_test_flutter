class TimeFrame {
  int id;
  String timeFrame;
  String shortTimeFrame;

  TimeFrame({this.id, this.timeFrame, this.shortTimeFrame});

  TimeFrame.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeFrame = json['time_frame'];
    shortTimeFrame = json['short_time_frame'];
  }
}
