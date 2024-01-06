import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_platform.dart';  // Import your existing LoginPlatform enum
import 'AuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String test = '3000';

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      // Update login platform using AuthService
      AuthService.saveToken(result.accessToken as String? ?? ''); // Save token
      AuthService.saveUserInfo({
        'id': result.account.id ?? '',
        'email': result.account.email ?? '',
        'name': result.account.name ?? '',
      }, 'naver'); // Save user info
    }
  }

  Future<void> signInWithGoogle() async {
    final BuildContext localContext = context;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final url = Uri.parse('http://143.248.228.29:3000/auth/google-login');
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthService.saveToken(googleAuth.accessToken ?? ''); // Save token
      AuthService.saveUserInfo({
        'id': googleUser.id,
        'email': googleUser.email,
        'name': googleUser.displayName ?? '',
      }, 'google');

      var res = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': googleUser.email,  // send gmail address to server
            'username': googleUser.displayName,  // send gmail user name to server
          })
      );

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var flag = data['flag'];
        if (flag == 1) {  // 새로운 계정인지 확인
          print("new account");
        } else {          // 기존 계정인지 확인
          print("existing account");

          // 비동기 함수 내에서 context 사용을 피하기 위해 Future.delayed 사용
          await Future.delayed(Duration.zero, () {
            Navigator.pop(context);
          });
        }
      } else {
        print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: signInWithGoogle,
              child: Text('Google로 로그인'),
            ),
            ElevatedButton(
              onPressed: signInWithNaver,
              child: Text('Naver로 로그인'),
            ),
          ],
            // Add other UI elements as needed
        ),
      ),
    );
  }
}