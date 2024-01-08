import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:madsports/GameDetailsPage.dart';
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
    setState(() { });
  }

  _fetch() async {
    final url = Uri.parse('http://143.248.228.45:3000/store/findwithname?findkey=엽떡');
    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        for (var game in data) {
          print('가게: ${game['place_name']} , 주소: ${game['address']}');
        }
      } else {
        print('서버로부터 데이터를 가져오는 데 오류가 발생했습니다. Status Code: ${res.statusCode}');
        print('Response Body: ${res.body}');
      }
    } catch (e) {
      print('Error: $e');
    }

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
              return ListView(
                padding: EdgeInsets.zero,
                children: userinfo_drawer(
                  snapshot.data!,
                  email,
                  name,
                  () {
                    navigateToLoginPage();
                  },
                  () {
                    signOut();
                  },
                  () { _fetch(); }
                ),
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

        List<String> game_info = get_game_by_date(tabDate);

        return ListView.builder(
          itemCount: game_info.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailsPage(matchTitle: game_info[index]),
                  ),
                );
              },
              child: ListTile(
                title: Text(game_info[index]),
              ),
            );
          },
        );
      }),
    );
  }
}