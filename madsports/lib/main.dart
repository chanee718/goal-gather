import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_platform.dart';

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
  int _counter = 0;

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

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.facebook:
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  _fetch() async {
    final url = Uri.parse('http://172.10.7.43:80/users');
    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("data: $data");
      } else {
        print('서버로부터 데이터를 가져오는 데 오류가 발생했습니다.');
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
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _fetch,
            tooltip: 'Fetch Data',
            child: const Icon(Icons.cloud_download),
          ),
          FloatingActionButton(
            onPressed: _loginPlatform != LoginPlatform.none ? signOut : signInWithNaver,
            tooltip: 'Naver Login',
            child: Image.asset('asset/image/naver_logo.png', width: 30.0, height: 30.0),
          )
        ],
      ),
    );
  }
}