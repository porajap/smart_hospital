class DataOfYearModel {
  DataOfYearModel({
      this.error, 
      this.status, 
      this.message, 
      this.data,});

  DataOfYearModel.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  num? status;
  String? message;
  Data? data;
DataOfYearModel copyWith({  bool? error,
  num? status,
  String? message,
  Data? data,
}) => DataOfYearModel(  error: error ?? this.error,
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
      this.men, 
      this.female,});

  Data.fromJson(dynamic json) {
    if (json['men'] != null) {
      men = [];
      json['men'].forEach((v) {
        men?.add(Men.fromJson(v));
      });
    }
    if (json['female'] != null) {
      female = [];
      json['female'].forEach((v) {
        female?.add(Female.fromJson(v));
      });
    }
  }
  List<Men>? men;
  List<Female>? female;
Data copyWith({  List<Men>? men,
  List<Female>? female,
}) => Data(  men: men ?? this.men,
  female: female ?? this.female,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (men != null) {
      map['men'] = men?.map((v) => v.toJson()).toList();
    }
    if (female != null) {
      map['female'] = female?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Female {
  Female({
      this.qDate, 
      this.year, 
      this.month, 
      this.monthName, 
      this.total,});

  Female.fromJson(dynamic json) {
    qDate = json['qDate'];
    year = json['year'];
    month = json['month'];
    monthName = json['monthName'];
    total = json['total'];
  }
  String? qDate;
  num? year;
  num? month;
  String? monthName;
  num? total;
Female copyWith({  String? qDate,
  num? year,
  num? month,
  String? monthName,
  num? total,
}) => Female(  qDate: qDate ?? this.qDate,
  year: year ?? this.year,
  month: month ?? this.month,
  monthName: monthName ?? this.monthName,
  total: total ?? this.total,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qDate'] = qDate;
    map['year'] = year;
    map['month'] = month;
    map['monthName'] = monthName;
    map['total'] = total;
    return map;
  }

}

class Men {
  Men({
      this.qDate, 
      this.year, 
      this.month, 
      this.monthName, 
      this.total,});

  Men.fromJson(dynamic json) {
    qDate = json['qDate'];
    year = json['year'];
    month = json['month'];
    monthName = json['monthName'];
    total = json['total'];
  }
  String? qDate;
  num? year;
  num? month;
  String? monthName;
  num? total;
Men copyWith({  String? qDate,
  num? year,
  num? month,
  String? monthName,
  num? total,
}) => Men(  qDate: qDate ?? this.qDate,
  year: year ?? this.year,
  month: month ?? this.month,
  monthName: monthName ?? this.monthName,
  total: total ?? this.total,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qDate'] = qDate;
    map['year'] = year;
    map['month'] = month;
    map['monthName'] = monthName;
    map['total'] = total;
    return map;
  }

}