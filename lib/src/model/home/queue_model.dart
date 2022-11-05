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
      this.memberId, 
      this.roomId, 
      this.roomName, 
      this.createdAt, 
      this.dateAt, 
      this.timeAt, 
      this.isConfirm, 
      this.queueDetail, 
      this.userDetail,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    queueNo = json['queueNo'];
    memberId = json['memberId'];
    roomId = json['roomId'];
    roomName = json['roomName'];
    createdAt = json['createdAt'];
    dateAt = json['dateAt'];
    timeAt = json['timeAt'];
    isConfirm = json['isConfirm'];
    queueDetail = json['queueDetail'] != null ? QueueDetail.fromJson(json['queueDetail']) : null;
    userDetail = json['userDetail'] != null ? UserDetail.fromJson(json['userDetail']) : null;
  }
  num? id;
  String? queueNo;
  num? memberId;
  num? roomId;
  String? roomName;
  String? createdAt;
  String? dateAt;
  String? timeAt;
  num? isConfirm;
  QueueDetail? queueDetail;
  UserDetail? userDetail;
Data copyWith({  num? id,
  String? queueNo,
  num? memberId,
  num? roomId,
  String? roomName,
  String? createdAt,
  String? dateAt,
  String? timeAt,
  num? isConfirm,
  QueueDetail? queueDetail,
  UserDetail? userDetail,
}) => Data(  id: id ?? this.id,
  queueNo: queueNo ?? this.queueNo,
  memberId: memberId ?? this.memberId,
  roomId: roomId ?? this.roomId,
  roomName: roomName ?? this.roomName,
  createdAt: createdAt ?? this.createdAt,
  dateAt: dateAt ?? this.dateAt,
  timeAt: timeAt ?? this.timeAt,
  isConfirm: isConfirm ?? this.isConfirm,
  queueDetail: queueDetail ?? this.queueDetail,
  userDetail: userDetail ?? this.userDetail,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['queueNo'] = queueNo;
    map['memberId'] = memberId;
    map['roomId'] = roomId;
    map['roomName'] = roomName;
    map['createdAt'] = createdAt;
    map['dateAt'] = dateAt;
    map['timeAt'] = timeAt;
    map['isConfirm'] = isConfirm;
    if (queueDetail != null) {
      map['queueDetail'] = queueDetail?.toJson();
    }
    if (userDetail != null) {
      map['userDetail'] = userDetail?.toJson();
    }
    return map;
  }

}

class UserDetail {
  UserDetail({
      this.id, 
      this.hnCode, 
      this.organizeId, 
      this.organizeName, 
      this.fNameTh, 
      this.mNameTh, 
      this.lNameTh, 
      this.fNameEng, 
      this.mNameEng, 
      this.lNameEng,});

  UserDetail.fromJson(dynamic json) {
    id = json['id'];
    hnCode = json['HnCode'];
    organizeId = json['organizeId'];
    organizeName = json['organizeName'];
    fNameTh = json['fNameTh'];
    mNameTh = json['mNameTh'];
    lNameTh = json['lNameTh'];
    fNameEng = json['fNameEng'];
    mNameEng = json['mNameEng'];
    lNameEng = json['lNameEng'];
  }
  num? id;
  String? hnCode;
  num? organizeId;
  String? organizeName;
  String? fNameTh;
  String? mNameTh;
  String? lNameTh;
  String? fNameEng;
  String? mNameEng;
  String? lNameEng;
UserDetail copyWith({  num? id,
  String? hnCode,
  num? organizeId,
  String? organizeName,
  String? fNameTh,
  String? mNameTh,
  String? lNameTh,
  String? fNameEng,
  String? mNameEng,
  String? lNameEng,
}) => UserDetail(  id: id ?? this.id,
  hnCode: hnCode ?? this.hnCode,
  organizeId: organizeId ?? this.organizeId,
  organizeName: organizeName ?? this.organizeName,
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
    map['organizeId'] = organizeId;
    map['organizeName'] = organizeName;
    map['fNameTh'] = fNameTh;
    map['mNameTh'] = mNameTh;
    map['lNameTh'] = lNameTh;
    map['fNameEng'] = fNameEng;
    map['mNameEng'] = mNameEng;
    map['lNameEng'] = lNameEng;
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
      this.isSuccess, 
      this.queueOfFront,});

  QueueDetail.fromJson(dynamic json) {
    id = json['id'];
    roomId = json['roomId'];
    roomName = json['roomName'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    queueOfRoom = json['queueOfRoom'];
    isSuccess = json['isSuccess'];
    queueOfFront = json['queueOfFront'];
  }
  num? id;
  num? roomId;
  String? roomName;
  dynamic startTime;
  dynamic endTime;
  num? queueOfRoom;
  num? isSuccess;
  num? queueOfFront;
QueueDetail copyWith({  num? id,
  num? roomId,
  String? roomName,
  dynamic startTime,
  dynamic endTime,
  num? queueOfRoom,
  num? isSuccess,
  num? queueOfFront,
}) => QueueDetail(  id: id ?? this.id,
  roomId: roomId ?? this.roomId,
  roomName: roomName ?? this.roomName,
  startTime: startTime ?? this.startTime,
  endTime: endTime ?? this.endTime,
  queueOfRoom: queueOfRoom ?? this.queueOfRoom,
  isSuccess: isSuccess ?? this.isSuccess,
  queueOfFront: queueOfFront ?? this.queueOfFront,
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
    map['queueOfFront'] = queueOfFront;
    return map;
  }

}