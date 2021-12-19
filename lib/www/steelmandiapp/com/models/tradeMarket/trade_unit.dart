class TradeUnit {
  int id;
  String name;
  String shortName;
  String createdAt;
  String updatedAt;

  TradeUnit(
      {this.id, this.name, this.shortName, this.createdAt, this.updatedAt});

  TradeUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
