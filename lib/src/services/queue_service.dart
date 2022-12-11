import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_hospital/src/model/home/queue_model.dart';
import 'package:smart_hospital/src/model/home/queue_of_front_model.dart';
import 'package:smart_hospital/src/model/location/room_location_model.dart';
import 'package:smart_hospital/src/model/response_model.dart';
import 'package:smart_hospital/src/services/preferences_service.dart';
import 'package:smart_hospital/src/services/urls.dart';
import 'package:smart_hospital/src/utils/date_time_format.dart';

import '../pages/my_app.dart';
import '../utils/constants.dart';
import 'custom_exception.dart';

class QueueService {
  final prefService = SharedPreferencesService();

  Future<QueueModel> scanQr({required String queueNo}) async {
    QueueModel _data = QueueModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.scanQr}/${queueNo}');

      final _response = await http.get(_url, headers: _header);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = QueueModel.fromJson(_jsonResponse);

      logger.w(_data.toJson());

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

  Future<QueueModel> queueOfUserToday() async {
    QueueModel _data = QueueModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.queueToday}');

      final _response = await http.get(_url, headers: _header);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = QueueModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

  Future<QueueModel> confirmQueue({
    required int queueId,
    required String queueNo,
    required int roomId,
  }) async {
    QueueModel _data = QueueModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      Map<String, dynamic> _body = {
        "id": '$queueId',
        "queueNo": '$queueNo',
        "roomId": '$roomId',
      };

      final _url = Uri.parse('${AppUrl.confirmQueue}');

      final _response = await http.post(
        _url,
        headers: _header,
        body: _body,
      );
      logger.w(_response.statusCode);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = QueueModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err.toString());
      return _data;
    }
  }

  Future<QueueOfFrontModel> queueOfFront({
    required String queueNo,
    required int queueOfRoom,
  }) async {
    QueueOfFrontModel _data = QueueOfFrontModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _dateNow = ConvertDateTimeFormat.convertDateFormat(date: DateTime.now(), format: "yyy-MM-dd");

      Map<String, dynamic> _body = {
        "createdAt": '$_dateNow',
        "queueNo": '$queueNo',
        "queueOfRoom": '$queueOfRoom',
      };


      final _url = Uri.parse('${AppUrl.queueOfFront}');

      final _response = await http.post(
        _url,
        headers: _header,
        body: _body,
      );

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = QueueOfFrontModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err.toString());
      return _data;
    }
  }

  Future<ResponseModel> updateHnCode({
    required String hnCode,
  }) async {
    ResponseModel _data = ResponseModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.updateHnCode}/${hnCode}');

      final _response = await http.get(
        _url,
        headers: _header,
      );
      logger.w(_response.statusCode);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = ResponseModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err.toString());
      return _data;
    }
  }

  Future<RoomLocationModel> getLocationOfRoom({required int roomId}) async {
    RoomLocationModel _data = RoomLocationModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.locationOfRoom}/${roomId}');

      final _response = await http.get(_url, headers: _header);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = RoomLocationModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

}
