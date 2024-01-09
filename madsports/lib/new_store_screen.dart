import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/temp_classes.dart';
import 'dart:io';

class NewStoreScreen extends StatefulWidget {
  final String email;
  final Function() onUpdate;
  const NewStoreScreen({super.key, required this.email, required this.onUpdate});

  @override
  State<NewStoreScreen> createState() => _NewStoreScreenState();
}

class _NewStoreScreenState extends State<NewStoreScreen> {
  final _picker = ImagePicker();
  late File? _imageFile;
  late TextEditingController _searchController = TextEditingController();
  late TextEditingController _screenController;
  late TextEditingController _menuController;
  late TextEditingController _capacity;
  String storeid = "";
  String name = "";
  dynamic searchedStores;

  Future<void> searchStore(String query) async {
    final results = await findStorewithName(query);
    setState(() {
      searchedStores = results;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "");
    _menuController = TextEditingController(text: "");
    _screenController = TextEditingController(text: "");
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
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Store'),
              onChanged: (value) async => await searchStore(value),
            ),
            // 검색 결과 리스트
            ListView.builder(
              shrinkWrap: true,
              itemCount: searchedStores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchedStores[index]['place_name']),
                  onTap: () {
                    // 선택된 가게 정보로 필드를 채움
                    storeid = searchedStores[index]['storeid'];
                    name = searchedStores[index]['name'];
                    _searchController.text = name;
                  },
                );
              },
            ),
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
                if(int.tryParse(_capacity.text) == null || storeid == "" || name == ""){
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
                await addStore(storeid, name, _imageFile?.path, _menuController.text, _screenController.text, int.tryParse(_capacity.text)!, widget.email);
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
