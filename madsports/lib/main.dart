import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';
import 'AuthService.dart';
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
  String test = '3000';
  late Future<bool> isLoggedIn;

  @override
  void initState() {
    super.initState();
    // 초기화 시 로그인 상태를 가져와 Future 변수에 할당
    isLoggedIn = isLoggedin();
  }

  Future<void> refreshState() async {
    // 상태를 갱신할 때 로그인 상태를 다시 가져옴
    setState(() {
      isLoggedIn = isLoggedin();
    });
  }

  Future<bool> isLoggedin() async {
    return await AuthService.getToken() != null && await AuthService.getLoginPlatform() != 'loggedOut';
  }

  void signOut() async {
    String loginPlatform = (await AuthService.getLoginPlatform()) ?? '';
    print('$loginPlatform');
    switch (loginPlatform) {
      case 'google':
        await GoogleSignIn().signOut();
        print("google logged out");
        break;
      case 'naver':
        await FlutterNaverLogin.logOut();
        print("naver logged out");
        break;
      case 'loggedOut':
        break;
    }
    await AuthService.logout();
    refreshState();
  }

  void navigateToLoginPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
    refreshState(); // 로그인 후 Main으로 돌아왔을 때 상태를 갱신
  }

  _fetch() async {
    final url = Uri.parse('http://143.248.228.29:3000/users');
    String loginPlatform = (await AuthService.getLoginPlatform()) ?? '';
    print('$loginPlatform');
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
            FutureBuilder<bool>(
              future: isLoggedin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == true) {
                    return ElevatedButton(
                      onPressed: signOut,
                      child: Text('Log Out'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: navigateToLoginPage,
                      child: Text('Log In'),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
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