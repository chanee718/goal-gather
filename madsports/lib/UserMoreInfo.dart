import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/main.dart';
import 'package:madsports/temp_classes.dart';
import 'dart:io';

class MoreUserInfo extends StatefulWidget {
  final String email;
  final String? base_name;
  final Function() onUpdate;
  const MoreUserInfo({super.key, required this.email, required this.base_name, required this.onUpdate});

  @override
  State<MoreUserInfo> createState() => _MoreUserInfo();
}

class _MoreUserInfo extends State<MoreUserInfo> {
  final _picker = ImagePicker();
  late File? _imageFile;
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  String _selectedType = "Goal Gather 이용자";
  List<String> _userTypes = ["Goal Gather 이용자", "가게 관리자"];
  bool showList = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.base_name);
    _typeController = TextEditingController(text: "");
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
        title: Text('추가 정보를 기입하세요', style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: '사용자 이름'),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: DropdownButton<String>(
                  value: _selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue!;
                      _typeController.text = newValue; // 선택된 값으로 TextEditingController 업데이트
                    });
                  },
                  items: _userTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
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
                  if (_nameController.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "사용자 이름을 입력해주세요!",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        fontSize: 20,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT
                    );
                    return;
                  }
                  if(_typeController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: "사용자 유형을 선택해주세요!",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        fontSize: 20,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT
                    );
                    return;
                  }
                  await editUserinfo(widget.email, _nameController.text, _imageFile?.path, _typeController.text);

                  // 초기 화면으로 돌아갑니다.
                  print("checkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyHomePage(title: 'Goal Gather')),
                  //       (Route<dynamic> route) => false,
                  // );
                  Navigator.pop(context);
                },
                child: Text('정보 저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}