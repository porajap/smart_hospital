class LoggedModel {
  LoggedModel({
      this.error, 
      this.message, 
      this.token, 
      this.data,});

  LoggedModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  String? message;
  String? token;
  Data? data;
LoggedModel copyWith({  bool? error,
  String? message,
  String? token,
  Data? data,
}) => LoggedModel(  error: error ?? this.error,
  message: message ?? this.message,
  token: token ?? this.token,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    map['token'] = token;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.phone, 
      this.fName, 
      this.lName, 
      this.hospitalName, 
      this.role,});

  Data.fromJson(dynamic json) {
    phone = json['phone'];
    fName = json['fName'];
    lName = json['lName'];
    hospitalName = json['hospitalName'];
    role = json['role'];
  }
  String? phone;
  String? fName;
  String? lName;
  String? hospitalName;
  num? role;
Data copyWith({  String? phone,
  String? fName,
  String? lName,
  String? hospitalName,
  num? role,
}) => Data(  phone: phone ?? this.phone,
  fName: fName ?? this.fName,
  lName: lName ?? this.lName,
  hospitalName: hospitalName ?? this.hospitalName,
  role: role ?? this.role,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = phone;
    map['fName'] = fName;
    map['lName'] = lName;
    map['hospitalName'] = hospitalName;
    map['role'] = role;
    return map;
  }

}