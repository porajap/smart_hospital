class QueueOfFrontModel {
  QueueOfFrontModel({
      this.error, 
      this.status, 
      this.message, 
      this.data,});

  QueueOfFrontModel.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  num? status;
  String? message;
  Data? data;
QueueOfFrontModel copyWith({  bool? error,
  num? status,
  String? message,
  Data? data,
}) => QueueOfFrontModel(  error: error ?? this.error,
  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.queueOfFront,});

  Data.fromJson(dynamic json) {
    queueOfFront = json['queueOfFront'];
  }
  num? queueOfFront;
Data copyWith({  num? queueOfFront,
}) => Data(  queueOfFront: queueOfFront ?? this.queueOfFront,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['queueOfFront'] = queueOfFront;
    return map;
  }

}