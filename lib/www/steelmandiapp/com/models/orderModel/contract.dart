class Contract {
  int contractId;
  String effectiveDate;
  String terminationDate;
  String buyer;
  String seller;

  // TradeBook Contract
  String partyType;
  String partyName;
  String status;
  int orderId;
  String orderSatus;

  Contract({this.contractId,
      this.effectiveDate,
      this.terminationDate,
      this.buyer,
      this.seller,
      this.status,
      this.partyName,
      this.partyType,
      this.orderId,
      this.orderSatus});

  Contract.fromJson(Map<String, dynamic> json) {
    contractId = json['contract_id'];
    effectiveDate = json['effective_date'];
    terminationDate = json['termination_date'];
    buyer = json['buyer'];
    seller = json['seller'];
    partyName = json['party_name'];
    status = json['contract_status'];
    partyType = json['party_type'];
    orderId = json['order_id'];
    orderSatus = json['order_status'];
  }
}
