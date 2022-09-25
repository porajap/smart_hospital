class DataOfDayModel {
  DataOfDayModel({
      this.error, 
      this.status, 
      this.message, 
      this.data,});

  DataOfDayModel.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  num? status;
  String? message;
  Data? data;
DataOfDayModel copyWith({  bool? error,
  num? status,
  String? message,
  Data? data,
}) => DataOfDayModel(  error: error ?? this.error,
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
      this.maxMin, 
      this.countPatient, 
      this.lastUpdated,});

  Data.fromJson(dynamic json) {
    maxMin = json['maxMin'] != null ? MaxMin.fromJson(json['maxMin']) : null;
    countPatient = json['countPatient'];
    lastUpdated = json['lastUpdated'];
  }
  MaxMin? maxMin;
  num? countPatient;
  String? lastUpdated;
Data copyWith({  MaxMin? maxMin,
  num? countPatient,
  String? lastUpdated,
}) => Data(  maxMin: maxMin ?? this.maxMin,
  countPatient: countPatient ?? this.countPatient,
  lastUpdated: lastUpdated ?? this.lastUpdated,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (maxMin != null) {
      map['maxMin'] = maxMin?.toJson();
    }
    map['countPatient'] = countPatient;
    map['lastUpdated'] = lastUpdated;
    return map;
  }

}

class MaxMin {
  MaxMin({
      this.min, 
      this.max,});

  MaxMin.fromJson(dynamic json) {
    min = json['min'] != null ? Min.fromJson(json['min']) : null;
    max = json['max'] != null ? Max.fromJson(json['max']) : null;
  }
  Min? min;
  Max? max;
MaxMin copyWith({  Min? min,
  Max? max,
}) => MaxMin(  min: min ?? this.min,
  max: max ?? this.max,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (min != null) {
      map['min'] = min?.toJson();
    }
    if (max != null) {
      map['max'] = max?.toJson();
    }
    return map;
  }

}

class Max {
  Max({
      this.startTime, 
      this.endTime, 
      this.minutes, 
      this.timeDiff,});

  Max.fromJson(dynamic json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    minutes = json['minutes'];
    timeDiff = json['timeDiff'];
  }
  String? startTime;
  String? endTime;
  num? minutes;
  String? timeDiff;
Max copyWith({  String? startTime,
  String? endTime,
  num? minutes,
  String? timeDiff,
}) => Max(  startTime: startTime ?? this.startTime,
  endTime: endTime ?? this.endTime,
  minutes: minutes ?? this.minutes,
  timeDiff: timeDiff ?? this.timeDiff,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['minutes'] = minutes;
    map['timeDiff'] = timeDiff;
    return map;
  }

}

class Min {
  Min({
      this.startTime, 
      this.endTime, 
      this.minutes, 
      this.timeDiff,});

  Min.fromJson(dynamic json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    minutes = json['minutes'];
    timeDiff = json['timeDiff'];
  }
  String? startTime;
  String? endTime;
  num? minutes;
  String? timeDiff;
Min copyWith({  String? startTime,
  String? endTime,
  num? minutes,
  String? timeDiff,
}) => Min(  startTime: startTime ?? this.startTime,
  endTime: endTime ?? this.endTime,
  minutes: minutes ?? this.minutes,
  timeDiff: timeDiff ?? this.timeDiff,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['minutes'] = minutes;
    map['timeDiff'] = timeDiff;
    return map;
  }

}