import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddChatRoomScreen extends StatefulWidget {
  const AddChatRoomScreen({super.key});

  @override
  State<AddChatRoomScreen> createState() => _AddChatRoomScreenState();
}


class _AddChatRoomScreenState extends State<AddChatRoomScreen> {
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

  // 채팅방 정보를 저장할 변수들
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _joinConditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('채팅방 추가')),
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
              controller: _nameController,
              decoration: InputDecoration(labelText: '채팅방 이름'),
            ),
            SizedBox(height: 16),

            // 채팅방 지역 입력 필드
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: '채팅방 지역'),
            ),
            SizedBox(height: 16),

            // 참여 조건 입력 필드
            TextFormField(
              controller: _joinConditionController,
              decoration: InputDecoration(labelText: '참여 조건'),
            ),
            SizedBox(height: 16),

            // 추가 버튼
            ElevatedButton(
              onPressed: () {
                // 채팅방 추가 로직 추가
              },
              child: Text('추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}