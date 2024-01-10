
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madsports/ShopListPage.dart';
import 'package:madsports/search_pref_team_screen.dart';

import 'AuthService.dart';

typedef LoginCallback = void Function();

List<Widget> userinfo_drawer(bool isLogin, String email, String name, LoginCallback onLoginPressed, LoginCallback onLogoutPressed, BuildContext con){

  return [

    UserAccountsDrawerHeader(
      accountName: isLogin == false ?
      const Text('로그인 필요', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 0, 53)),) : Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 0, 53)),),
      accountEmail: isLogin == false ?
      const Text('로그인 필요', style: TextStyle(color: Color.fromARGB(255, 43, 0, 53)),) : Text(email, style: const TextStyle(color: Color.fromARGB(255, 43, 0, 53)),),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage('asset/image/sample_background.gif'),
      ),
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage('asset/image/naver_logo.png'),
          //     fit: BoxFit.cover
          // ),
          color: Color.fromARGB(255, 72, 252, 155)
      ),
    ),
    ListTile(
      leading: Icon(Icons.sports_soccer_sharp, color: Color.fromARGB(255, 43, 0, 53),),
      title: Text('관심 팀', style: TextStyle(color: Color.fromARGB(255, 43, 0, 53)),),
      onTap: (){
        if(isLogin == false){
          Fluttertoast.showToast(
              msg: "Login First!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              fontSize: 20,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT
          );
        }
        else {
          Navigator.push(
            con,
            MaterialPageRoute(
              builder: (con) => PrefTeamScreen(email: email),
            ),
          );
        }
      },
    ),
    ListTile(
      leading: Icon(Icons.chat, color: Color.fromARGB(255, 43, 0, 53)),
      title: Text('참여 중인 채팅방', style: TextStyle(color: Color.fromARGB(255, 43, 0, 53))),
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
      leading: Icon(Icons.store, color: Color.fromARGB(255, 43, 0, 53)),
      title: Text('내 음식점', style: TextStyle(color: Color.fromARGB(255, 43, 0, 53))),
      onTap: () {
        if(isLogin == false){
          Fluttertoast.showToast(
              msg: "Login First!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              fontSize: 20,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT
          );
        }
        else {
          Navigator.push(
            con,
            MaterialPageRoute(
              builder: (con) => ShopListPage(email: email),
            ),
          );
        }
      },
    ),
    Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            child:ElevatedButton(
              onPressed: () {
                if (isLogin == false) {
                  onLoginPressed();
                } else {
                  onLogoutPressed();
                }
              },
              child: isLogin == false ? const Text('Login', style: TextStyle(color: Colors.white)) : const Text('Logout', style: TextStyle(color: Colors.red)),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 43, 0, 53),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 약간 둥근 모서리 설정
                ),
              ),
            ),
          ),
        ),
      ),
  ];
}