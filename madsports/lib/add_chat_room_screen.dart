import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:madsports/functions.dart';

class AddChatRoomScreen extends StatefulWidget {
  final String email;
  final int game;
  final Function() onUpdate;
  const AddChatRoomScreen({super.key, required this.email, required this.game, required this.onUpdate});

  @override
  State<AddChatRoomScreen> createState() => _AddChatRoomScreenState();
}


class _AddChatRoomScreenState extends State<AddChatRoomScreen> {
  // 선택된 이미지를 저장할 변수
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _linkController;
  late TextEditingController _authController;
  late TextEditingController _regionController;
  late TextEditingController _capacity;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _linkController = TextEditingController(text: "");
    _authController = TextEditingController(text: "");
    _regionController = TextEditingController(text: "");
    _capacity = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로운 채팅방 생성'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 검색 필드
            // 검색 결과 리스트
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset('asset/image/naver_logo.png', width: 200, height: 200),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300), // Adjust width here
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: '채팅방 제목'),
                    ),
                    TextField(
                      controller: _authController,
                      decoration: InputDecoration(labelText: '참여 조건'),
                    ),
                    TextField(
                      controller: _linkController,
                      decoration: InputDecoration(labelText: '채팅방 url'),
                    ),
                    TextField(
                      controller: _regionController,
                      decoration: InputDecoration(labelText: '지역'),
                    ),
                    TextField(
                      controller: _capacity,
                      decoration: InputDecoration(labelText: '채팅방 인원'),
                    ),
                  ]
                ),
              ),
            ),
            SizedBox(height:20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 300),
                child: ElevatedButton(
                  onPressed: () async {
                    if(int.tryParse(_capacity.text) == null){
                      Fluttertoast.showToast(
                          msg: "Wrong format!",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          fontSize: 20,
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_SHORT
                      );
                      return;
                    }
                    await createNewChat(widget.email, widget.game, _nameController.text, null, _regionController.text, int.tryParse(_capacity.text)! , _authController.text, _linkController.text);
                    // Store 객체를 업데이트합니다.

                    // Callback 함수를 호출하여 상태를 업데이트합니다.
                    widget.onUpdate();

                    // 초기 화면으로 돌아갑니다.
                    Navigator.pop(context);
                  },
                  child: Text('정보 저장', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 43, 0, 53),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // 약간 둥근 모서리 설정
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}