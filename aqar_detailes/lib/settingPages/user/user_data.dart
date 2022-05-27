import 'dart:convert';

import 'package:aqar_detailes/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    name: Data.userInfo.isNotEmpty
        ? '${Data.userInfo[0]['Name']}'
        : 'fName sName',
    email: Data.userInfo.isNotEmpty
        ? '${Data.userInfo[0]['Email']}'
        : 'Name@gmail.com',
    phone: Data.userInfo.isNotEmpty
        ? '${Data.userInfo[0]['PhoneNumber']}'
        : '0783875641',
    Password: '',
  );

  ///////////////////////////
  static Future<void> updateUserInfo(String apiName, Info, updateInfo) async {
    String url = "${Data.apiPath}$apiName"; //name=Mohammad%20Bahlaq&uid=1
    http.post(
      Uri.parse(url),
      body: {Info: updateInfo, "uid": "${Data.userInfo[0]['UID']}"},
    );
  }
  //////////////////////////

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
