import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'login_platform.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LoginPlatform _loginPlatform = LoginPlatform.none;
  static const baseUrl = 'http://143.248.228.117:3000/users';
  String test = '3000';

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      setState(() {
        _loginPlatform = LoginPlatform.naver;
      });
    }
  }

  void NaversignOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final url = Uri.parse('http://143.248.228.29:3000/auth/google-login');
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('Google User Email: ${googleUser.email}');
      print('Google User Display Name: ${googleUser.displayName}');

      print('email type: ${googleUser.email.runtimeType}');
      print('name type: ${googleUser.displayName.runtimeType}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
        test = googleUser.email ?? '';
      });

      var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': googleUser.email,
          'username': googleUser.displayName,
        })
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);

        // 응답에서 원하는 데이터 추출
        String message = data['message'];
        int userId = data['userId'];

        // 메시지 출력 또는 화면 업데이트 등의 로직 추가
        print(message);
        print('User ID: $userId');

        // 여기서 메시지나 사용자 ID를 화면에 출력하거나 다른 화면 업데이트 작업을 수행할 수 있습니다.
      } else {
        print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      }


    }
  }

  void GooglesignOut() async {
    await GoogleSignIn().signOut();
    setState(() {
      _loginPlatform = LoginPlatform.none;
      test = 'logged out';
    });
  }

  _fetch() async {
    final url = Uri.parse('http://143.248.228.29:3000/users');
    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data: $data");
        setState(() {
          test = data[1]['email'];
        });
      } else {
        print('서버로부터 데이터를 가져오는 데 오류가 발생했습니다. Status Code: ${res.statusCode}');
        print('Response Body: ${res.body}');
      }
      // 성공적으로 응답을 받았을 때의 코드
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              test,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (_loginPlatform == LoginPlatform.none) ...[
              ElevatedButton(
                onPressed: signInWithGoogle,
                child: Text('Google로 로그인'),
              ),
              ElevatedButton(
                onPressed: signInWithNaver,
                child: Text('Naver로 로그인'),
              ),
            ],
            if (_loginPlatform == LoginPlatform.google || _loginPlatform == LoginPlatform.naver)
              ElevatedButton(
                onPressed: () {
                  if (_loginPlatform == LoginPlatform.google) {
                    GooglesignOut();
                  } else if (_loginPlatform == LoginPlatform.naver) {
                    NaversignOut();
                  }
                },
                child: Text('로그아웃'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
              ),
            // WebView 추가
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _fetch,
            tooltip: 'Fetch Data',
            child: const Icon(Icons.cloud_download),
          ),
        ],
      ),
    );
  }
}