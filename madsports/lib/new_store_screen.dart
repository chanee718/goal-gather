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
  late File? _imageFile;
  late TextEditingController _searchController = TextEditingController();
  late TextEditingController _screenController;
  late TextEditingController _menuController;
  late TextEditingController _capacity;
  String storeid = "";
  String name = "";
  String number = "";
  String address = "";
  dynamic searchedStores;
  bool showList = true;

  Future<void> searchStore(String query) async {
    showList = true;
    final results = await findStorewithName(query);
    if(results == null) return;
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
    searchedStores = Map();
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
                // 검색 필드
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(labelText: 'Search Store'),
                  onChanged: (value) async => await searchStore(value),
                ),
                // 검색 결과 리스트
                showList? ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedStores.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchedStores[index]['place_name']),
                      subtitle: Text(searchedStores[index]['address']),
                      onTap: () {
                        // 선택된 가게 정보로 필드를 채움
                        storeid = searchedStores[index]['id'];
                        name = searchedStores[index]['place_name'];
                        number = searchedStores[index]['number'];
                        address = searchedStores[index]['address'];
                        print("$storeid, $name, $number, $address");
                        _searchController.text = name;
                        setState(() {
                          showList = false;
                        });
                      },
                    );
                  },
                ): Container(),
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
                SizedBox(height:20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 300),
                    child: ElevatedButton(
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
                        await addStore(storeid, name, number, address, null, _menuController.text, _screenController.text, int.tryParse(_capacity.text)!, widget.email);
                        await updateStore(storeid, null, _menuController.text, _screenController.text, int.tryParse(_capacity.text)!);
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
            ),
    ],
                ),
      ),
    );
  }
}