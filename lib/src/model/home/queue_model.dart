class QueueModel {
  QueueModel({
      this.error, 
      this.status, 
      this.message, 
      this.data,});

  QueueModel.fromJson(dynamic json) {
    error = json['error'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? error;
  num? status;
  String? message;
  Data? data;
QueueModel copyWith({  bool? error,
  num? status,
  String? message,
  Data? data,
}) => QueueModel(  error: error ?? this.error,
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
      this.queueNo, 
      this.roomId, 
      this.roomName, 
      this.createdAt, 
      this.dateAt, 
      this.timeAt, 
      this.isConfirm, 
      this.queueDetail,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    queueNo = json['queueNo'];
    roomId = json['roomId'];
    roomName = json['roomName'];
    createdAt = json['createdAt'];
    dateAt = json['dateAt'];
    timeAt = json['timeAt'];
    isConfirm = json['isConfirm'];
    queueDetail = json['queueDetail'] != null ? QueueDetail.fromJson(json['queueDetail']) : null;
  }
  num? id;
  String? queueNo;
  num? roomId;
  String? roomName;
  String? createdAt;
  String? dateAt;
  String? timeAt;
  num? isConfirm;
  QueueDetail? queueDetail;
Data copyWith({  num? id,
  String? queueNo,
  num? roomId,
  String? roomName,
  String? createdAt,
  String? dateAt,
  String? timeAt,
  num? isConfirm,
  QueueDetail? queueDetail,
}) => Data(  id: id ?? this.id,
  queueNo: queueNo ?? this.queueNo,
  roomId: roomId ?? this.roomId,
  roomName: roomName ?? this.roomName,
  createdAt: createdAt ?? this.createdAt,
  dateAt: dateAt ?? this.dateAt,
  timeAt: timeAt ?? this.timeAt,
  isConfirm: isConfirm ?? this.isConfirm,
  queueDetail: queueDetail ?? this.queueDetail,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['queueNo'] = queueNo;
    map['roomId'] = roomId;
    map['roomName'] = roomName;
    map['createdAt'] = createdAt;
    map['dateAt'] = dateAt;
    map['timeAt'] = timeAt;
    map['isConfirm'] = isConfirm;
    if (queueDetail != null) {
      map['queueDetail'] = queueDetail?.toJson();
    }
    return map;
  }

}

class QueueDetail {
  QueueDetail({
      this.id, 
      this.roomId, 
      this.roomName, 
      this.startTime, 
      this.endTime, 
      this.queueOfRoom, 
      this.isSuccess,});

  QueueDetail.fromJson(dynamic json) {
    id = json['id'];
    roomId = json['roomId'];
    roomName = json['roomName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    queueOfRoom = json['queueOfRoom'];
    isSuccess = json['isSuccess'];
  }
  num? id;
  num? roomId;
  String? roomName;
  String? startTime;
  String? endTime;
  num? queueOfRoom;
  num? isSuccess;
QueueDetail copyWith({  num? id,
  num? roomId,
  String? roomName,
  String? startTime,
  String? endTime,
  num? queueOfRoom,
  num? isSuccess,
}) => QueueDetail(  id: id ?? this.id,
  roomId: roomId ?? this.roomId,
  roomName: roomName ?? this.roomName,
  startTime: startTime ?? this.startTime,
  endTime: endTime ?? this.endTime,
  queueOfRoom: queueOfRoom ?? this.queueOfRoom,
  isSuccess: isSuccess ?? this.isSuccess,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['roomId'] = roomId;
    map['roomName'] = roomName;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['queueOfRoom'] = queueOfRoom;
    map['isSuccess'] = isSuccess;
    return map;
  }

}