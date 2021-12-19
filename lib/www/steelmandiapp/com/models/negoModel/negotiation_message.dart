import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/last_negotiation.dart';

class NegotiationMessage extends NegotiationListItem {
  int id;
  String textMessage;
  int negotiationId;
  int proposerId;
  int requestResponderId;
  String createdAt;
  String updatedAt;

  NegotiationMessage(
      {this.id,
      this.textMessage,
      this.negotiationId,
      this.proposerId,
      this.requestResponderId,
      this.createdAt,
      this.updatedAt});

  NegotiationMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    textMessage = json['text_message'];
    negotiationId = json['negotiation_id'];
    proposerId = json['proposer_id'];
    requestResponderId = json['request_responder_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text_message'] = this.textMessage;
    data['negotiation_id'] = this.negotiationId;
    data['proposer_id'] = this.proposerId;
    data['request_responder_id'] = this.requestResponderId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
