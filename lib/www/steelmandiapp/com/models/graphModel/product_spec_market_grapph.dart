class GraphData {
  int id;
  DateTime dateTime;
  double price;

  GraphData({this.id, this.dateTime, this.price});

  GraphData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = DateTime.parse(json['date_time']);
    price = json['price'] is double ? json['price'] : json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_time'] = this.dateTime;
    data['price'] = this.price;
    return data;
  }
}
