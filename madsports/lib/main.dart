import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:madsports/GameDetailsPage.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/userinfodrawer.dart';
import 'login_page.dart';
import 'package:madsports/sample_query.dart';
import 'dart:convert';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'AuthService.dart';

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const baseUrl = 'http://172.10.7.43:80/users';
  String test = '3000';
  String email = '';
  String name = '';

  late TabController _tabController;
  late DateTime currentDate;

  @override
  void initState() {
    currentDate = DateTime.now();
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {
      currentDate = currentDate.add(Duration(days: _tabController.index - 6));
    });
  }
  void navigateToLoginPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage())
    );
    Map<String, dynamic>? userInfo = await AuthService.getUserInfo();

    // userInfo가 null이 아니면, 즉 사용자 정보가 존재하면 name을 출력
    if (userInfo != null) {
      name = userInfo['name'];
      email = userInfo['email'];
    }
    setState(() { });
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
    name = '';
    email = '';
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    _tabController = TabController(
        animationDuration: const Duration(milliseconds: 800),
        length: 13,
        initialIndex: 6,
        vsync: this
    );
    _tabController.addListener(() {
      setState(() {
        currentDate = currentDate.add(Duration(days: _tabController.index - 6));
      });
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabBarView(),
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<bool>(
          future: AuthService.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
                // isLoggedIn()이 true일 때
                return FutureBuilder<Map<String, dynamic>?>(
                  future: AuthService.getUserInfo(),
                  builder: (context, userInfoSnapshot) {
                    if (userInfoSnapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic>? userInfo = userInfoSnapshot.data;
                        return ListView(
                            padding: EdgeInsets.zero,
                            children: userinfo_drawer(
                              snapshot.data!,
                              userInfo?['email'] ?? '로그인 하세요',
                              userInfo?['name'] ?? '로그인 하세요',
                                () {
                                navigateToLoginPage();
                                }, () {
                                signOut();
                                },
                                context)
                        );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
        tabs: List.generate(13, (index) {
          DateTime tabDate = currentDate.subtract(Duration(days: 6 - index));
          String formattedDate = DateFormat('MM/dd').format(tabDate);
          return Tab(
            text: formattedDate,
          );
        }),
        onTap: (index) {},
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: List.generate(13, (index) {
        DateTime tabDate = currentDate.subtract(Duration(days: 6 - index));
        String formattedDate = DateFormat('yyyy-MM-dd').format(tabDate);

        return FutureBuilder(
          future: findGamebyDate(formattedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // 로딩 인디케이터 표시
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              dynamic game_info = snapshot.data;
              return ListView.builder(
                itemCount: game_info.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDetailsPage(game_info: game_info[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(game_info[index]['homeTeamName'] + ' vs ' +game_info[index]['awayTeamName']),
                    ),
                  );
                },
              );
            }
          },
        );
      }),
    );
  }
}