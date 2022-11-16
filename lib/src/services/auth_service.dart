import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:smart_hospital/src/model/login/logged_model.dart';
import 'package:smart_hospital/src/services/preferences_service.dart';
import 'package:smart_hospital/src/services/urls.dart';

import '../../main.dart';
import '../model/login/check_phone_model.dart';
import '../pages/my_app.dart';
import '../utils/constants.dart';
import 'custom_exception.dart';
import 'notification_service.dart';

class AuthService {
  final prefService = SharedPreferencesService();

  Future<CheckPhoneModel> checkPhone({required String phone}) async {
    CheckPhoneModel _data = CheckPhoneModel();

    try {
      var _response;

      if (phone == "") {
        throw AuthenticationException(message: '${Constants.textLoginFailed}');
      }

      final _url = Uri.parse('${AppUrl.checkPhone}/$phone');

      _response = await http.get(_url).timeout(
        Duration(seconds: 3),
        onTimeout: () {
          throw AuthenticationException(message: '${Constants.textInternetLost}');
        },
      );

      logger.i(_response.body);

      if (_response.statusCode == 200) {
        final _jsonResponse = json.decode(_response.body);
        _data = CheckPhoneModel.fromJson(_jsonResponse);

        await prefService.setPhone(phone: phone);

      } else if (_response.statusCode == 404) {
        final _jsonResponse = json.decode(_response.body);
        _data = CheckPhoneModel.fromJson(_jsonResponse);
      }

      return _data;
    } on SocketException {
      throw AuthenticationException(message: '${Constants.textInternetLost}');
    } on TimeoutException {
      throw AuthenticationException(message: '${Constants.textInternetLost}');
    }
  }

  Future<LoggedModel> createPin({required String pin}) async {
    LoggedModel _data = LoggedModel();

    try {
      var _response;

      final _phone = await prefService.getPhone();

      final _url = Uri.parse('${AppUrl.cretePin}');

      Map<String, dynamic> _body = {
        'phone': _phone,
        'pin': pin,
      };

      _response = await http.post(_url, body: _body).timeout(
        Duration(seconds: 3),
        onTimeout: () {
          throw AuthenticationException(message: '${Constants.textInternetLost}');
        },
      );

      if (_response.statusCode != 200) {
        throw AuthenticationException(message: '${Constants.textLoginFailed}');
      }

      final _jsonResponse = json.decode(_response.body);

      _data = LoggedModel.fromJson(_jsonResponse);

      bool _error = _data.error ?? false;
      if(!_error){
        await prefService.setIsLoggedIn(isLogin: true);
        await prefService.setUserLoggedIn(data: _data);
        FirebaseMessaging.instance.getToken().then(setTokenFCM);
      }

      return _data;
    } on SocketException {
      throw AuthenticationException(message: '${Constants.textInternetLost}');
    } on TimeoutException {
      throw AuthenticationException(message: '${Constants.textInternetLost}');
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

  Future<LoggedModel> login({required String pin}) async {
    LoggedModel _data = LoggedModel();

    try {
      var _response;

      final _phone = await prefService.getPhone();

      final _url = Uri.parse('${AppUrl.login}');

      Map<String, dynamic> _body = {
        'phone': _phone,
        'pin': pin,
      };

      _response = await http.post(_url, body: _body).timeout(
        Duration(seconds: 3),
        onTimeout: () {
          throw AuthenticationException(message: '${Constants.textInternetLost}');
        },
      );

      if (_response.statusCode != 200) {
        throw AuthenticationException(message: '${Constants.textLoginFailed}');
      }

      final _jsonResponse = json.decode(_response.body);

      _data = LoggedModel.fromJson(_jsonResponse);

      bool _error = _data.error ?? false;
      if(!_error){
        await prefService.setIsLoggedIn(isLogin: true);
        await prefService.setUserLoggedIn(data: _data);
        FirebaseMessaging.instance.getToken().then(setTokenFCM);
      }

      return _data;
    } on SocketException {
      throw AuthenticationException(message: '${Constants.textInternetLost}');
    } on TimeoutException {
      throw AuthenticationException(message: '${Constants.textInternetLost}');
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

  void setTokenFCM(String? token) async{
    logger.w('FCM Token: $token');

    var _notifyService = NotificationService();

    await _notifyService.addToken(token: token ?? "", platform: Platform.isAndroid ? "android" : "ios");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        pushNotificationService.showFlutterNotification(message);
      }
    });
  }

  Future<void> logout() async {
    await prefService.setIsLoggedIn(isLogin: false);
    await prefService.clearDataUser();
    loggerNoStack.w("log out successfully");
    return await Future<void>.delayed(Duration(seconds: 1));
  }
}
