class ResponseFlags {
  String responseStatus;
  String responseMessage;
  int statusCode;

  ResponseFlags(
      {this.responseMessage =
          'Something went wrong\nPlease check your connectivity.',
      this.responseStatus = 'error',
      this.statusCode});

  ResponseFlags.fromJson(Map<String, dynamic> json) {
    responseStatus = json['response_status'];
    responseMessage = json['response_message'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_status'] = this.responseStatus;
    data['response_message'] = this.responseMessage;
    data['status_code'] = this.statusCode;
    return data;
  }
}
