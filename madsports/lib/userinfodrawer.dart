import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:madsports/login_platform.dart';

List<Widget> userinfo_drawer(LoginPlatform loginPlatform, String email, String name){
  return [

    UserAccountsDrawerHeader(
      accountName: loginPlatform == LoginPlatform.none ?
      const Text('로그인 필요', style: TextStyle(color: Colors.white),) : Text(name, style: const TextStyle(color: Colors.white),),
      accountEmail: loginPlatform == LoginPlatform.none ?
      const Text('로그인 필요', style: TextStyle(color: Colors.white),) : Text(email, style: const TextStyle(color: Colors.white),),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: AssetImage('asset/image/sample_background.gif'),
      ),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('asset/image/naver_logo.png'),
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
    ElevatedButton(
        onPressed: (){
          Fluttertoast.showToast(
              msg: "Login!!!!!!!",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              fontSize: 20,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT
          );
        },
        child: loginPlatform == LoginPlatform.none? const Text('Login') : const Text('Logout')
    )
  ];
}