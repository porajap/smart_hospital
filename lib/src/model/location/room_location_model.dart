class RoomLocationModel {
  RoomLocationModel({
      this.error, 
      this.status, 
      this.message, 
      this.data,});

  RoomLocationModel.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  num? status;
  String? message;
  Data? data;
RoomLocationModel copyWith({  bool? error,
  num? status,
  String? message,
  Data? data,
}) => RoomLocationModel(  error: error ?? this.error,
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
      this.name, 
      this.longitude, 
      this.latitude,});

  Data.fromJson(dynamic json) {
    name = json['name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }
  String? name;
  num? longitude;
  num? latitude;
Data copyWith({  String? name,
  num? longitude,
  num? latitude,
}) => Data(  name: name ?? this.name,
  longitude: longitude ?? this.longitude,
  latitude: latitude ?? this.latitude,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    return map;
  }

}