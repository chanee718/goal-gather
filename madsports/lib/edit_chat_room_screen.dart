import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:madsports/temp_classes.dart';

class EditChatRoomScreen extends StatefulWidget {
  dynamic ChatRoom;
  final Function() onUpdate;
  EditChatRoomScreen({super.key, required this.ChatRoom, required this.onUpdate});

  @override
  State<EditChatRoomScreen> createState() => _EditChatRoomScreenState();
}



class _EditChatRoomScreenState extends State<EditChatRoomScreen> {
  // 선택된 이미지를 저장할 변수
  File? _selectedImage;

  // ImagePicker 인스턴스 생성
  final ImagePicker _picker = ImagePicker();

  // 이미지 선택 메서드
  Future _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('채팅방 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이미지 선택 부분
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                )
                    : Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),

            // 채팅방 이름 입력 필드
            TextFormField(
              decoration: InputDecoration(labelText: '채팅방 이름'),
              // 채팅방 이름 관련 로직 추가
            ),
            SizedBox(height: 16),

            // 채팅방 지역 입력 필드
            TextFormField(
              decoration: InputDecoration(labelText: '채팅방 지역'),
              // 채팅방 지역 관련 로직 추가
            ),
            SizedBox(height: 16),

            // 참여 조건 입력 필드
            TextFormField(
              decoration: InputDecoration(labelText: '참여 조건'),
              // 참여 조건 관련 로직 추가
            ),
            SizedBox(height: 16),

            // 수정 버튼
            ElevatedButton(
              onPressed: () {
                // 채팅방 정보 업데이트 로직 추가
              },
              child: Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}