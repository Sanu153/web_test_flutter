enum AnnotationType { BuySell, CurrentMarketPrice }

class Annotation {
  double price;
  double quantity;
  DateTime dateTime;
  String buySell;
  AnnotationType annotationType;

  Annotation(
      {this.price,
      this.quantity,
      this.dateTime,
      this.buySell,
      this.annotationType});
}
