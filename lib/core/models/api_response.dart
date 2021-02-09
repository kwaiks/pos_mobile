class ApiResponse {
  int status;
  String message;
  dynamic data;

  ApiResponse({this.data, this.status, this.message});

  ApiResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'];
}
