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
  final _picker = ImagePicker();
  late File? _imageFile;
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
    _imageFile = null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가게 상세 정보'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 검색 필드
            // 검색 결과 리스트
            if (_imageFile != null) Image.file(_imageFile!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('채팅방 사진 변경'),
            ),
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
            // 수용 인원 설정 UI는 추가 구현 필요
            ElevatedButton(
              onPressed: () async {
                if(_imageFile == null){
                  Fluttertoast.showToast(
                      msg: "Please upload image!",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      fontSize: 20,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT
                  );
                  return;
                }
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
                await createNewChat(widget.email, widget.game, _nameController.text, _imageFile?.path, _regionController.text, int.tryParse(_capacity.text)! , _authController.text, _linkController.text);
                // Store 객체를 업데이트합니다.

                // Callback 함수를 호출하여 상태를 업데이트합니다.
                widget.onUpdate();

                // 초기 화면으로 돌아갑니다.
                Navigator.pop(context);
              },
              child: Text('정보 저장'),
            ),
          ],
        ),
      ),
    );
  }
}