import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  static const baseUrl = 'http://172.10.7.43:80/users';
  int _counter = 0;
  String test = '3000';
  String email = '';
  String name = '';

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');
      email = result.account.email;
      name = result.account.name;

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
        email = googleUser.email;
        name = googleUser.id;
      });
    }
  }

  void GooglesignOut() async {
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            UserAccountsDrawerHeader(
              accountName: _loginPlatform == LoginPlatform.none ?
                const Text('로그인 필요', style: TextStyle(color: Colors.white),) : Text(name, style: const TextStyle(color: Colors.white),),
              accountEmail: _loginPlatform == LoginPlatform.none ?
                const Text('로그인 필요', style: TextStyle(color: Colors.white),) : Text(email, style: const TextStyle(color: Colors.white),),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/sample_background.gif'),
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/naver_logo.png'),
                      fit: BoxFit.cover
                  ),
                color: Colors.amber
              ),
            ),
            ListTile(
              leading: Icon(Icons.sports),
              title: Text('My favorite Team'),
              onTap: (){
                Fluttertoast.showToast(
                  msg: "edit team",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  fontSize: 20,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('My chattings'),
              onTap: (){
                Fluttertoast.showToast(
                  msg: "edit chat",
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  fontSize: 20,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_SHORT
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('My Shop'),
              onTap: (){
                Fluttertoast.showToast(
                    msg: "edit shop",
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    fontSize: 20,
                    textColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}