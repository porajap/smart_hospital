class ResponseModel {
  ResponseModel({
      this.error, 
      this.message,});

  ResponseModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
  }
  bool? error;
  String? message;
ResponseModel copyWith({  bool? error,
  String? message,
}) => ResponseModel(  error: error ?? this.error,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    return map;
  }

}