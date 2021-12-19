abstract class ProductItem {}

class ProType implements ProductItem {
  String name;
  int id;

  ProType({this.id, this.name});
}
