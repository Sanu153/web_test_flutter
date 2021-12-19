class ResponseResult<T> {
  T data;

  ResponseResult({this.data});
}

class Success<T> {
  T data;

  Success({this.data});
}

class Failure {
  String responseStatus;
  String responseMessage;
  int statusCode;

  Failure(
      {this.responseMessage = "Something went wrong", this.responseStatus = "InternalError", this.statusCode});

  Failure.fromJson(Map<String, dynamic> json) {
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
