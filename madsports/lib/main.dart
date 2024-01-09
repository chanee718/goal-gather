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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(10, 72, 252, 155)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Goal Gather'),
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

  void _goToToday() {
    setState(() {
      currentDate = DateTime.now(); // 현재 날짜를 오늘로 설정
      _tabController.animateTo(7); // 탭 컨트롤러의 인덱스를 중간으로 설정
    });
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
    _tabController.animation!.addListener(() {
      if (_tabController.animation!.status == AnimationStatus.completed) {
        setState(() {
          currentDate = currentDate.add(Duration(days: _tabController.index - 6));
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 16.0),
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _goToToday();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: FutureBuilder<Widget>(
              future: _buildTabBarView(), // 비동기 함수 호출
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // 로딩 인디케이터
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // 에러 처리
                } else {
                  return snapshot.data ?? SizedBox.shrink(); // 데이터 로드 완료
                }
              },
            ),
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
        onTap: (index) {
          _tabController.animateTo(
            index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        tabs: List.generate(13, (index) {
          DateTime tabDate = currentDate.subtract(Duration(days: 6 - index));
          String formattedDate = DateFormat('MM/dd').format(tabDate);
          String tabText;
          if (formattedDate == DateFormat('MM/dd').format(DateTime.now())) {
            tabText = '오늘';
          } else if (formattedDate == DateFormat('MM/dd').format(DateTime.now().subtract(Duration(days: 1)))) {
            tabText = '어제';
          } else if (formattedDate == DateFormat('MM/dd').format(DateTime.now().add(Duration(days: 1)))) {
            tabText = '내일';
          } else {
            tabText = formattedDate;
          }

          return Tab(text: tabText);
        }),
      ),
    );
  }

  Future<Widget> _buildTabBarView() async {
    Map<String, dynamic>? userInfo = await AuthService.getUserInfo();
    return TabBarView(
      controller: _tabController,
      children: List.generate(13, (index) {
        DateTime tabDate = currentDate.subtract(Duration(days: 6 - index));
        String formattedDate = DateFormat('yyyy-MM-dd').format(tabDate);
        // return Column(
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         insertGame(formattedDate);
        //       },
        //       child: Text("Insert"),
        //     ),
        //   ],
        // );
        return FutureBuilder(
          future: findGamebyDate(formattedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data.length == 0) {
              return Center(child: Text("No Games Today", style: TextStyle(fontSize: 24)));
            } else {
              List<dynamic> games = snapshot.data;
              Map<String, List<dynamic>> groupedGames = groupByLeague(games);

              return ListView(
                children: groupedGames.entries.map((entry) {
                  return _buildLeagueCard(entry.key, entry.value, userInfo);
                }).toList(),
              );
            }
          },
        );
      }),
    );
  }
  Map<String, List<dynamic>> groupByLeague(List<dynamic> games) {
    Map<String, List<dynamic>> leagueGroups = {};
    for (var game in games) {
      String league = game['league'];
      leagueGroups.putIfAbsent(league, () => []);
      leagueGroups[league]!.add(game);
    }
    return leagueGroups;
  }

  // 리그별 카드를 구축하는 함수
  Widget _buildLeagueCard(String league, List<dynamic> leagueGames, Map<String, dynamic>? userInfo) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // 모서리 둥글기 설정
      ),
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 43, 0, 53),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
            ),
            child: ListTile(
              title: Text(league, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              contentPadding: EdgeInsets.symmetric(vertical: -1.0, horizontal: 16.0),
            ),
          ),
          ...List.generate(leagueGames.length, (index) {
            var game = leagueGames[index];
            return index == leagueGames.length - 1
                ? Container(
                  margin: EdgeInsets.only(bottom: 3.0), // 마지막 ListTile에만 아래쪽 패딩 추가
                  child: _buildGameTile(game, userInfo),
                )
                : _buildGameTile(game, userInfo);
          }),
        ],
      ),
    );
  }

  Widget _buildGameTile(dynamic game, Map<String, dynamic>? userInfo) {
    return InkWell(
      onTap: () {
        if(userInfo == null){
          Fluttertoast.showToast(
              msg: "Login First!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              fontSize: 20,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailsPage(game_info: game, email: userInfo['email']),
          ),
        );
      },
      child: ListTile(
        leading: Image.network(game['homeTeamImage'], width: 30, height: 30),
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  game['homeTeamName'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(game['startTime'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500],)),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  game['awayTeamName'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        trailing: Image.network(game['awayTeamImage'], width: 30, height: 30),
        tileColor: Colors.transparent,
      ),
    );
  }
}