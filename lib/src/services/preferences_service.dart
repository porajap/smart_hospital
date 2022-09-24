import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_hospital/src/model/login/logged_model.dart';

class PreferenceKey {
  static final String isLogin = "isLogin";
  static final String phone = "phone";

  static final String fName = "fName";
  static final String lName = "lName";
  static final String hospitalName = "hospitalName";
  static final String role = "role";
  static final String token = "token";
}

class SharedPreferencesService {
  Future<void> setIsLoggedIn({required bool isLogin}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(PreferenceKey.isLogin, isLogin);
  }

  Future<bool> getIsLoggedIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool _data = _prefs.getBool(PreferenceKey.isLogin) ?? false;
    return _data;
  }

  Future<int> getRole() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int _data = _prefs.getInt(PreferenceKey.role) ?? 0;
    return _data;
  }

  Future<void> clearDataUser() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }


  Future<void> setUserLoggedIn({required LoggedModel data}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.setString(PreferenceKey.fName, data.data?.fName ?? "");
    _prefs.setString(PreferenceKey.lName, data.data?.lName ?? "");
    _prefs.setString(PreferenceKey.hospitalName, data.data?.hospitalName ?? "");
    _prefs.setInt(PreferenceKey.role, data.data?.role as int);
    _prefs.setString(PreferenceKey.token, data.token ?? "");
  }

  Future<String> getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _data = _prefs.getString(PreferenceKey.token) ?? "";
    return _data;
  }


  Future<String> getPhone() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _data = _prefs.getString(PreferenceKey.phone) ?? "";
    return _data;
  }

  Future<void> setPhone({required String phone}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceKey.phone, phone);
  }
}
