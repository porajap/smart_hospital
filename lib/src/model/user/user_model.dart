class UserModel {
  UserModel({
      this.error, 
      this.status, 
      this.message, 
      this.data,});

  UserModel.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  num? status;
  String? message;
  Data? data;
UserModel copyWith({  bool? error,
  num? status,
  String? message,
  Data? data,
}) => UserModel(  error: error ?? this.error,
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
      this.id, 
      this.hnCode, 
      this.hospitalCode, 
      this.hospitalName, 
      this.fNameTh, 
      this.mNameTh, 
      this.lNameTh, 
      this.fNameEng, 
      this.mNameEng, 
      this.lNameEng,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    hnCode = json['HnCode'];
    hospitalCode = json['hospitalCode'];
    hospitalName = json['hospitalName'];
    fNameTh = json['fNameTh'];
    mNameTh = json['mNameTh'];
    lNameTh = json['lNameTh'];
    fNameEng = json['fNameEng'];
    mNameEng = json['mNameEng'];
    lNameEng = json['lNameEng'];
  }
  num? id;
  String? hnCode;
  num? hospitalCode;
  String? hospitalName;
  String? fNameTh;
  dynamic mNameTh;
  String? lNameTh;
  String? fNameEng;
  dynamic mNameEng;
  String? lNameEng;
Data copyWith({  num? id,
  String? hnCode,
  num? hospitalCode,
  String? hospitalName,
  String? fNameTh,
  dynamic mNameTh,
  String? lNameTh,
  String? fNameEng,
  dynamic mNameEng,
  String? lNameEng,
}) => Data(  id: id ?? this.id,
  hnCode: hnCode ?? this.hnCode,
  hospitalCode: hospitalCode ?? this.hospitalCode,
  hospitalName: hospitalName ?? this.hospitalName,
  fNameTh: fNameTh ?? this.fNameTh,
  mNameTh: mNameTh ?? this.mNameTh,
  lNameTh: lNameTh ?? this.lNameTh,
  fNameEng: fNameEng ?? this.fNameEng,
  mNameEng: mNameEng ?? this.mNameEng,
  lNameEng: lNameEng ?? this.lNameEng,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['HnCode'] = hnCode;
    map['hospitalCode'] = hospitalCode;
    map['hospitalName'] = hospitalName;
    map['fNameTh'] = fNameTh;
    map['mNameTh'] = mNameTh;
    map['lNameTh'] = lNameTh;
    map['fNameEng'] = fNameEng;
    map['mNameEng'] = mNameEng;
    map['lNameEng'] = lNameEng;
    return map;
  }

}