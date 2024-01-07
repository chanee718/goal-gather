import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String tokenKey = 'user_token';
  static const String userInfoKey = 'user_info';
  static const String platformKey = 'loggedOut';

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<void> saveUserInfo(Map<String, dynamic> userInfo, String platform) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userInfoKey, json.encode(userInfo));
    await prefs.setString(platformKey, platform);
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString(userInfoKey);
    return userInfoString != null ? json.decode(userInfoString) : null;
  }

  static Future<String?> getLoginPlatform() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(platformKey);
  }

  static Future<void> logout() async {
    // 로컬에서 토큰 및 유저 정보 삭제
    await removeToken();
    await removeUserInfo();
    await removeLoginPlatform();
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userInfoKey);
  }

  static Future<void> removeLoginPlatform() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(platformKey);
  }

  static Future<bool> isLoggedIn() async {
    final String? token = await getToken();
    return token != null;
  }
}