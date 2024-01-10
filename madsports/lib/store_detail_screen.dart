import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/temp_classes.dart';
import 'dart:io';


class StoreDetailScreen extends StatefulWidget {
  final dynamic store;
  final Function() onUpdate;
  const StoreDetailScreen({super.key, required this.store, required this.onUpdate});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  late TextEditingController _screenController;
  late TextEditingController _menuController;
  late TextEditingController _capacity;

  @override
  void initState() {
    super.initState();
    _menuController = TextEditingController(text: widget.store['mainmenu']);
    _screenController = TextEditingController(text: widget.store['screen']);
    _capacity = TextEditingController(text: widget.store['capacity'].toString());
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
                            await updateStore(widget.store['store_id'], null, _menuController.text, _screenController.text, int.tryParse(_capacity.text)!);
                            // Store 객체를 업데이트합니다.
                            print("object");
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
                    // 수용 인원 설정 UI는 추가 구현 필요

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