import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/temp_classes.dart';
import 'dart:io';

import 'add_store_screen.dart';

class StoreDetailScreen extends StatefulWidget {
  final dynamic store;
  final Function() onUpdate;
  const StoreDetailScreen({super.key, required this.store, required this.onUpdate});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final _picker = ImagePicker();
  late File? _imageFile;
  late TextEditingController _screenController;
  late TextEditingController _menuController;
  late TextEditingController _capacity;

  @override
  void initState() {
    super.initState();
    _menuController = TextEditingController(text: widget.store['mainmenu']);
    _screenController = TextEditingController(text: widget.store['screen']);
    _capacity = TextEditingController(text: widget.store['capacity'].toString());
    _imageFile = widget.store['store_image'] != null ? File(widget.store['store_image']) : null;
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
              child: Text('가게 사진 변경'),
            ),
            TextField(
              controller: _menuController,
              decoration: InputDecoration(labelText: '주 메뉴'),
            ),
            TextField(
              controller: _screenController,
              decoration: InputDecoration(labelText: '스크린 정보'),
            ),
            TextField(
              controller: _capacity,
              decoration: InputDecoration(labelText: '수용 가능 인원'),
            ),
            // 수용 인원 설정 UI는 추가 구현 필요
            ElevatedButton(
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
                print(widget.store['store_id']);
                await updateStore(widget.store['store_id'], _imageFile?.path, _menuController.text, _screenController.text, int.tryParse(_capacity.text)!);
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