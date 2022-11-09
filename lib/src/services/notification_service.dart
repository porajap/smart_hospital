import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_hospital/src/services/preferences_service.dart';
import 'package:smart_hospital/src/services/urls.dart';

import '../model/response_model.dart';
import '../pages/my_app.dart';
import 'custom_exception.dart';

class NotificationService {
  final prefService = SharedPreferencesService();

  Future<ResponseModel> addToken({required String token, required String platform}) async {
    ResponseModel _data = ResponseModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.addToken}');

      Map<String, dynamic> _body = {
        "token": token,
        "platform": platform,
      };

      final _response = await http.post(_url, headers: _header, body: _body);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);
      _data = ResponseModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }
}
