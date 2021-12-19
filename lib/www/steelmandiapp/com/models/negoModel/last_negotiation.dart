import 'package:steelmandi_app/www/steelmandiapp/com/models/enumModel/enum.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/negotiation_message.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

abstract class NegotiationListItem {}

class ApproveRejectMessage extends NegotiationListItem {
  String message;
  NegotiationAction negotiationAction;
  int actionProposerId;
  UserModel user;

  ApproveRejectMessage(
      {this.message, this.negotiationAction, this.actionProposerId, this.user});
}

class NegotiationValidationError extends NegotiationListItem {
  String responseMessage;
  String responseStatus;
  double remainingQuantity;

  NegotiationValidationError(
      {this.responseMessage, this.responseStatus, this.remainingQuantity});
}

class Negotiation extends NegotiationListItem {
  int id;
  int requestResponderId;
  double pricePerUnit;
  int paymentsInDays;
  int deliveryInDays;
  int proposerId;
  String createdAt;
  String updatedAt;
  String place;
  int tradeUnitId;
  double quantity;
  List<NegotiationMessage> negotiationChatMessages;

  Negotiation(
      {this.id,
      this.requestResponderId,
      this.pricePerUnit,
      this.paymentsInDays,
      this.deliveryInDays,
      this.proposerId,
      this.createdAt,
      this.updatedAt,
      this.place,
      this.tradeUnitId,
      this.negotiationChatMessages,
      this.quantity});

  Negotiation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestResponderId = json['request_responder_id'];
    pricePerUnit = json['price_per_unit'];
    paymentsInDays = json['payments_in_days'];
    deliveryInDays = json['delivery_in_days'];
    proposerId = json['proposer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    place = json['place'];
    tradeUnitId = json['trade_unit_id'];
    quantity = json['quantity'];
    if (json['negotiation_chat_messages'] != null) {
      negotiationChatMessages = new List<NegotiationMessage>();
      json['negotiation_chat_messages'].forEach((v) {
        negotiationChatMessages.add(new NegotiationMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_responder_id'] = this.requestResponderId;
    data['price_per_unit'] = this.pricePerUnit;
    data['payments_in_days'] = this.paymentsInDays;
    data['delivery_in_days'] = this.deliveryInDays;
    data['proposer_id'] = this.proposerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['place'] = this.place;
    data['trade_unit_id'] = this.tradeUnitId;
    data['quantity'] = this.quantity;
    if (this.negotiationChatMessages != null) {
      data['negotiation_chat_messages'] =
          this.negotiationChatMessages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
