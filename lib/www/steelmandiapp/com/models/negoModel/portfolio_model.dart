import 'package:steelmandi_app/www/steelmandiapp/com/models/negoModel/open_negotiation.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/userModel/user_model.dart';

class Portfolio {
  UserModel owner;
  int openNegotiationsCount;
  int closedNegotiationsCount;
  List<OpenNegotiation> listOfOpenNegotiations;
  List<OpenNegotiation> listOfCLosedNegotiations;

  Portfolio(
      {this.owner,
      this.openNegotiationsCount,
      this.listOfOpenNegotiations,
      this.closedNegotiationsCount,
      this.listOfCLosedNegotiations});

  Portfolio.fromJson(Map<String, dynamic> json) {
    owner =
        json['owner'] != null ? new UserModel.fromJson(json['owner']) : null;
    openNegotiationsCount = json['open_negotiations_count'];
    closedNegotiationsCount = json['close_negotiations_count'];
    if (json['list_of_open_negotiations'] != null) {
      listOfOpenNegotiations = new List<OpenNegotiation>();
      json['list_of_open_negotiations'].forEach((v) {
        listOfOpenNegotiations.add(new OpenNegotiation.fromJson(v));
      });
    }
    if (json['list_of_close_negotiations'] != null) {
      listOfCLosedNegotiations = new List<OpenNegotiation>();
      json['list_of_close_negotiations'].forEach((v) {
        listOfCLosedNegotiations.add(new OpenNegotiation.fromJson(v));
      });
    }
  }
}
