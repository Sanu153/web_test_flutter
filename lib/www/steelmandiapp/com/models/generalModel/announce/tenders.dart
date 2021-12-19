class Tenders {
  int id;
  String title;
  String product;
  String quantity;
  String location;
  String openingDate;
  String dueDate;
  Null description;
  int views;
  String createdAt;
  String updatedAt;
  String link;
  int publisherDetailId;
  List<TendersKeywords> tendersKeywords;
  PublisherDetail publisherDetail;

  Tenders(
      {this.id,
      this.title,
      this.product,
      this.quantity,
      this.location,
      this.openingDate,
      this.dueDate,
      this.description,
      this.views,
      this.createdAt,
      this.updatedAt,
      this.link,
      this.publisherDetailId,
      this.tendersKeywords,
      this.publisherDetail});

  Tenders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    product = json['product'];
    quantity = json['quantity'];
    location = json['location'];
    openingDate = json['opening_date'];
    dueDate = json['due_date'];
    description = json['description'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    link = json['link'];
    publisherDetailId = json['publisher_detail_id'];
    if (json['tenders_keywords'] != null) {
      tendersKeywords = new List<TendersKeywords>();
      json['tenders_keywords'].forEach((v) {
        tendersKeywords.add(new TendersKeywords.fromJson(v));
      });
    }
    publisherDetail = json['publisher_detail'] != null
        ? new PublisherDetail.fromJson(json['publisher_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['product'] = this.product;
    data['quantity'] = this.quantity;
    data['location'] = this.location;
    data['opening_date'] = this.openingDate;
    data['due_date'] = this.dueDate;
    data['description'] = this.description;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['link'] = this.link;
    data['publisher_detail_id'] = this.publisherDetailId;
    if (this.tendersKeywords != null) {
      data['tenders_keywords'] =
          this.tendersKeywords.map((v) => v.toJson()).toList();
    }
    if (this.publisherDetail != null) {
      data['publisher_detail'] = this.publisherDetail.toJson();
    }
    return data;
  }
}

class TendersKeywords {
  int id;
  String keyword;

  TendersKeywords({this.id, this.keyword});

  TendersKeywords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keyword'] = this.keyword;
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
