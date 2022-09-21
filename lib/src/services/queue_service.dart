import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_hospital/src/model/home/queue_model.dart';
import 'package:smart_hospital/src/services/preferences_service.dart';
import 'package:smart_hospital/src/services/urls.dart';

import '../pages/my_app.dart';
import '../utils/constants.dart';
import 'custom_exception.dart';

class QueueService {
  final prefService = SharedPreferencesService();

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

      logger.w(_data.toJson());

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

  Future<QueueModel> scanQr() async {
    QueueModel _data = QueueModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.scanQr}');

      final _response = await http.post(_url, headers: _header);

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
}
