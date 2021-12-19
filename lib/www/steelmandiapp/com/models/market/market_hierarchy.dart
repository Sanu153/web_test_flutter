class MarketHierarchy {
  int id;
  int marketHierarchyLevel;
  int parentMarketId;
  String name;
  String createdAt;
  String updatedAt;
  String marketType;
  String description;
  String link;

  MarketHierarchy(
      {this.id,
      this.marketHierarchyLevel,
      this.parentMarketId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.marketType,
      this.description,
      this.link});

  MarketHierarchy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marketHierarchyLevel = json['market_hierarchy_level'];
    parentMarketId = json['parent_market_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    marketType = json['market_type'];
    description = json['description'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['market_hierarchy_level'] = this.marketHierarchyLevel;
    data['parent_market_id'] = this.parentMarketId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['market_type'] = this.marketType;
    data['description'] = this.description;
    data['link'] = this.link;
    return data;
  }
}
