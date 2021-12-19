class Events {
  int id;
  String title;
  String venue;
  String dateTime;
  String description;
  int views;
  String createdAt;
  String updatedAt;
  String link;
  int publisherDetailId;
  PublisherDetail publisherDetail;

  Events(
      {this.id,
      this.title,
      this.venue,
      this.dateTime,
      this.description,
      this.views,
      this.createdAt,
      this.updatedAt,
      this.link,
      this.publisherDetailId,
      this.publisherDetail});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    venue = json['venue'];
    dateTime = json['date_time'];
    description = json['description'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    link = json['link'];
    publisherDetailId = json['publisher_detail_id'];
    publisherDetail = json['publisher_detail'] != null
        ? new PublisherDetail.fromJson(json['publisher_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['venue'] = this.venue;
    data['date_time'] = this.dateTime;
    data['description'] = this.description;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['link'] = this.link;
    data['publisher_detail_id'] = this.publisherDetailId;
    if (this.publisherDetail != null) {
      data['publisher_detail'] = this.publisherDetail.toJson();
    }
    return data;
  }
}

class PublisherDetail {
  int id;
  String name;
  String icon;

  PublisherDetail({this.id, this.name, this.icon});

  PublisherDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}
