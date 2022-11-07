import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  eliminarPref(String key) {
    _prefs.remove(key);
  }

  // GET y SET del token
  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  List<String> get constumerList {
    return _prefs.getStringList('constumerList') ?? [];
  }

  set constumerList(List<String> value) {
    _prefs.setStringList('constumerList', value);
  }

  List<String> get waitting {
    return _prefs.getStringList('waitting') ?? [];
  }

  set waitting(List<String> value) {
    _prefs.setStringList('waitting', value);
  }

  String get agendPref {
    return _prefs.getString('agendPref') ?? '';
  }

  set agendPref(String value) {
    _prefs.setString('agendPref', value);
  }

  // dataBase of the user
  String get bigData {
    return _prefs.getString('bigData') ?? '';
  }

  set bigData(String value) {
    _prefs.setString('bigData', value);
  }

  // autoAuth
  // bool get autoAuth {
  //   return _prefs.getBool('autoAuth') ?? false;
  // }

  // set autoAuth(bool value) {
  //   _prefs.setBool('autoAuth', value);
  // }
}
