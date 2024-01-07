import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:madsports/userinfodrawer.dart';
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  LoginPlatform _loginPlatform = LoginPlatform.none;
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



  @override
  Widget build(BuildContext context) {

    _tabController = TabController(
        animationDuration: const Duration(milliseconds: 800),
        length: 13,
        initialIndex: 6,
        vsync: this
    );
    _tabController.addListener((){
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: userinfo_drawer(_loginPlatform, email, name),
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
        onTap: (index){

        },
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: List.generate(13, (index) {
        DateTime tabDate = currentDate.subtract(Duration(days: 6 - index));
        String formattedDate = DateFormat('yyyy-MM-dd').format(tabDate);
        return Center(
          child: Text(
            'Content for $formattedDate',
            style: TextStyle(fontSize: 20),
          ),
        );
      }),
    );
  }


}