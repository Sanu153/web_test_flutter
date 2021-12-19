import 'package:steelmandi_app/www/steelmandiapp/com/models/productModels/tim_frame.dart';

class ProductSpec {
  int id;
  String name;
  Specification specification;
  String taxes;
  String createdAt;
  String updatedAt;
  int productId;
  String dispName;
  String dispIcon;
  String description;
  String link;
  List<TimeFrame> timeFrame;
  TimeFrame defaultTimeFrame;

  ProductSpec({this.timeFrame,
    this.id,
    this.name,
    this.specification,
    this.taxes,
    this.createdAt,
    this.updatedAt,
    this.productId,
    this.dispName,
    this.dispIcon,
    this.description,
    this.link,
    this.defaultTimeFrame});

  ProductSpec.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    specification = json['specification'] != null
        ? new Specification.fromJson(json['specification'])
        : null;
    taxes = json['taxes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productId = json['product_id'];
    dispName = json['disp_name'];
    dispIcon = json['disp_icon'];
    description = json['description'];
    link = json['link'];
    if (json['time_frames'] != null) {
      timeFrame = List<TimeFrame>();
      json['time_frames'].forEach((value) {
        timeFrame.add(TimeFrame.fromJson(value));
      });
    }
    this.defaultTimeFrame = json['default_time_frame'] != null
        ? TimeFrame.fromJson(json['default_time_frame'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.specification != null) {
      data['specification'] = this.specification.toJson();
    }
    data['taxes'] = this.taxes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_id'] = this.productId;
    data['disp_name'] = this.dispName;
    data['disp_icon'] = this.dispIcon;
    data['description'] = this.description;
    data['link'] = this.link;
    return data;
  }
}

class Specification {
  String size;
  String grade;
  String origin;

  Specification({this.size, this.grade, this.origin});

  Specification.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    grade = json['grade'];
    origin = json['origin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['grade'] = this.grade;
    data['origin'] = this.origin;
    return data;
  }
}
