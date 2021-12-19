import 'dart:io';

abstract class SupportItem {}

class SupportChat extends SupportItem {
  int id;
  User user;
  File document;
  String text;
  String imagePath;

  SupportChat({this.id, this.user, this.document, this.text, this.imagePath});

  SupportChat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    document = json['document'];
    text = json['text'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['document'] = this.document;
    data['text'] = this.text;
    data['imagePath'] = this.imagePath;

    return data;
  }
}

class User {
  int id;
  String name;
  String profile;
  String mobile;
  String email;

  User({this.id, this.name, this.profile, this.mobile, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profile = json['profile'];
    mobile = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile'] = this.profile;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}

class Suggestion extends SupportItem {
  String text;
  int id;

  Suggestion({this.text, this.id});

  Suggestion.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['id'] = this.id;
    return data;
  }
}

List<SupportItem> supportChartData = [
  Suggestion(text: "How to trade", id: 1),
  Suggestion(text: "How to Raise Buy Request", id: 2),
  Suggestion(text: "How to Raise Sell Request", id: 3),
  SupportChat(
      id: 1,
      document: null,
      text:
          'Orientation In Chat Screen: Orientation.portrait.Orientation In Chat Screen: Orientation.portrait ',
      imagePath: null,
      user: User(
          id: 7,
          email: "something@email.com",
          mobile: "9090803061",
          name: "Support",
          profile:
              "https://cdn.pixabay.com/photo/2020/01/27/10/28/appetite-4796886__340.jpg")),
  SupportChat(
    id: 2,
    document: null,
    text: 'Getting error in submitting buy a request ',
    imagePath:
        "https://cdn.pixabay.com/photo/2020/01/27/19/04/macbook-4798095__340.jpg",
    user: User(
        id: 27,
        email: "something@email.com",
        mobile: "9090803061",
        name: "Support",
        profile:
            "https://cdn.pixabay.com/photo/2020/01/27/19/04/macbook-4798095__340.jpg"),
  ),
  SupportChat(
      id: 2,
      document: null,
      text: 'Getting error in submitting buy a request ',
      imagePath: null,
      user: User(
          id: 6,
          email: "mrutyunjaya@gmail.com",
          mobile: "9090803061",
          name: "Mrutyunjaya",
          profile:
              "https://avatars0.githubusercontent.com/u/32695902?s=400&u=ae3551bff73e6322f338e6afe7dea989e0d9e6b3&v=4")),
  SupportChat(
      id: 2,
      document: null,
      text: 'SOmething happen ',
      imagePath: null,
      user: User(
          id: 6,
          email: "mrutyunjaya@gmail.com",
          mobile: "9090803061",
          name: "Mrutyunjaya",
          profile:
              "https://avatars0.githubusercontent.com/u/32695902?s=400&u=ae3551bff73e6322f338e6afe7dea989e0d9e6b3&v=4")),
];
