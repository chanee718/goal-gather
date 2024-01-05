import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
  int _counter = 0;
  String test = '3000';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    }
  }

  void signOut() async {
    await GoogleSignIn().signOut();
    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  _fetch() async {
    final url = Uri.parse('$baseUrl?test=$test');
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
            if (_loginPlatform == LoginPlatform.none)
              ElevatedButton(
                  onPressed: signInWithGoogle,
                  child: Text('Google로 로그인'),
              ),
            if (_loginPlatform == LoginPlatform.google)
              ElevatedButton(
                  onPressed: signOut,
                  child: Text('로그아웃'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
              )
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
        ],
      ),
    );
  }
}