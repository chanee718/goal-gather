import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'dart:io';

import 'package:madsports/temp_classes.dart';

class EditChatRoomScreen extends StatefulWidget {
  final dynamic ChatRoom;
  final Function() onUpdate;
  EditChatRoomScreen({super.key, required this.ChatRoom, required this.onUpdate});

  @override
  State<EditChatRoomScreen> createState() => _EditChatRoomScreenState();
}



class _EditChatRoomScreenState extends State<EditChatRoomScreen> {
  final _picker = ImagePicker();
  late File? _imageFile;
  late TextEditingController _nameController;
  late TextEditingController _linkController;
  late TextEditingController _authController;
  late TextEditingController _capacity;
  late String storeid;
  late String name;
  late String number;
  late String category;
  late String address;
  late String? pre_store;
  bool showList = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ChatRoom['chat_name']);
    _linkController = TextEditingController(text: widget.ChatRoom['chat_link']);
    _authController = TextEditingController(text: widget.ChatRoom['partici_auth']);
    _capacity = TextEditingController(text: widget.ChatRoom['capacity'].toString());
    _imageFile = File(widget.ChatRoom['chat_image']);


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
              controller: _capacity,
              decoration: InputDecoration(labelText: '채팅방 인원'),
            ),
            Text(
                widget.ChatRoom['reserved_store_name'] == null ? "예약된 식당: 없음" : "예약된 식당: ${widget.ChatRoom['reserved_store_name']}",
                style: TextStyle(fontSize: 16)
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
                // if(containedDB(storeid) == false) await addStore(storeid, name, number, address, image, menu, screen, capacity, email)
                await updateChat(widget.ChatRoom['id'], _nameController.text, _imageFile?.path, widget.ChatRoom['region'], int.tryParse(_capacity.text)!, _authController.text, _linkController.text);
                // Store 객체를 업데이트합니다.
                print(widget.ChatRoom['id']);
                print(_nameController.text);
                print(_imageFile?.path);
                print(widget.ChatRoom['region']);
                print(int.tryParse(_capacity.text)!);
                print(_authController.text);
                print(_linkController.text);

                // Callback 함수를 호출하여 상태를 업데이트합니다.
                widget.onUpdate();
                print("WHY");

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