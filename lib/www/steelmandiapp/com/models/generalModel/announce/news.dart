class News {
  int id;
  String author;
  String title;
  String description;
  int likes;
  int views;
  String createdAt;
  String updatedAt;
  String link;
  String publishedDateTime;
  int publisherDetailId;
  String timePassed;
  List<NewsKeywords> newsKeywords;
  PublisherDetail publisherDetail;
  List<NewsLikes> newsLikes;

  News(
      {this.id,
      this.author,
      this.title,
      this.description,
      this.likes,
      this.views,
      this.createdAt,
      this.updatedAt,
      this.link,
      this.publishedDateTime,
      this.publisherDetailId,
      this.timePassed,
      this.newsKeywords,
      this.publisherDetail,
      this.newsLikes});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    title = json['title'];
    description = json['description'];
    likes = json['likes'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    link = json['link'];
    publishedDateTime = json['published_date_time'];
    publisherDetailId = json['publisher_detail_id'];
    timePassed = json['time_passed'];
    if (json['news_keywords'] != null) {
      newsKeywords = new List<NewsKeywords>();
      json['news_keywords'].forEach((v) {
        newsKeywords.add(new NewsKeywords.fromJson(v));
      });
    }
    publisherDetail = json['publisher_detail'] != null
        ? new PublisherDetail.fromJson(json['publisher_detail'])
        : null;
    if (json['news_likes'] != null) {
      newsLikes = new List<NewsLikes>();
      json['news_likes'].forEach((v) {
        newsLikes.add(new NewsLikes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['likes'] = this.likes;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['link'] = this.link;
    data['published_date_time'] = this.publishedDateTime;
    data['publisher_detail_id'] = this.publisherDetailId;
    data['time_passed'] = this.timePassed;
    if (this.newsKeywords != null) {
      data['news_keywords'] = this.newsKeywords.map((v) => v.toJson()).toList();
    }
    if (this.publisherDetail != null) {
      data['publisher_detail'] = this.publisherDetail.toJson();
    }
    if (this.newsLikes != null) {
      data['news_likes'] = this.newsLikes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewsKeywords {
  int id;
  String keyword;

  NewsKeywords({this.id, this.keyword});

  NewsKeywords.fromJson(Map<String, dynamic> json) {
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

class NewsLikes {
  int id;

  NewsLikes({this.id});

  NewsLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
