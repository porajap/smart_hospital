class CheckPhoneModel {
  CheckPhoneModel({
      this.error, 
      this.message, 
      this.data,});

  CheckPhoneModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  String? message;
  Data? data;
CheckPhoneModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => CheckPhoneModel(  error: error ?? this.error,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.firstLogin, 
      this.phone,});

  Data.fromJson(dynamic json) {
    firstLogin = json['firstLogin'];
    phone = json['phone'];
  }
  bool? firstLogin;
  String? phone;
Data copyWith({  bool? firstLogin,
  String? phone,
}) => Data(  firstLogin: firstLogin ?? this.firstLogin,
  phone: phone ?? this.phone,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstLogin'] = firstLogin;
    map['phone'] = phone;
    return map;
  }

}