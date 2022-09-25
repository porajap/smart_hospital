import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smart_hospital/src/model/dashboard/data_of_day_model.dart';
import 'package:smart_hospital/src/model/dashboard/data_of_year_model.dart';
import 'package:smart_hospital/src/services/preferences_service.dart';
import 'package:smart_hospital/src/services/urls.dart';

import '../pages/my_app.dart';
import 'custom_exception.dart';


class DashboardService{
  final prefService = SharedPreferencesService();

  Future<DataOfYearModel> getDataOfYear() async {
    DataOfYearModel _data = DataOfYearModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _year = DateTime.now().year;

      final _url = Uri.parse('${AppUrl.dataOfYear}/$_year');

      final _response = await http.get(_url, headers: _header);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = DataOfYearModel.fromJson(_jsonResponse);

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

  Future<DataOfDayModel> getDataOfDay() async {
    DataOfDayModel _data = DataOfDayModel();

    try {
      final _token = await prefService.getToken();

      final _header = {
        HttpHeaders.authorizationHeader: '$_token',
      };

      final _url = Uri.parse('${AppUrl.dataOfDay}');

      final _response = await http.get(_url, headers: _header);

      if (_response.statusCode == 401) {
        throw AuthenticationUnauthorized();
      }

      final _jsonResponse = json.decode(_response.body);

      _data = DataOfDayModel.fromJson(_jsonResponse);

      logger.i(_data.toJson());

      return _data;
    } catch (err) {
      logger.e(err);
      return _data;
    }
  }

}