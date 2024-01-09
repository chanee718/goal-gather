import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/new_store_screen.dart';
import 'package:madsports/store_detail_screen.dart';
import 'package:madsports/temp_classes.dart';
import 'dart:io';

import 'add_store_screen.dart';


class ShopListPage extends StatefulWidget {
  final String email;
  ShopListPage({super.key, required this.email});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}


class _ShopListPageState extends State<ShopListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stores'),
      ),
      body: FutureBuilder<dynamic>(
        future: findMyStore(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중에 로딩 인디케이터를 표시합니다.
            return CircularProgressIndicator();
          }

          // 데이터가 준비되었을 때 UI를 구성합니다.
          dynamic stores = snapshot.data!;
          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: stores[index]['store_image'] != null
                    ? Image.file(
                  File(stores[index]['store_image']!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : Container(),
                title: Text(stores[index]['store_name']),
                subtitle: Text('Main Menu: ${stores[index]['mainmenu']}, Capacity: ${stores[index]['capacity']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreDetailScreen(
                        store: stores[index],
                        onUpdate: (){
                          setState(() {

                          });
                        }, // callback 함수 전달
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 가게 등록 화면으로 이동하고 등록된 가게를 리스트에 추가
          Store? newStore = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewStoreScreen(
                email: widget.email,
                onUpdate: () {
                  setState(() {

                  });
                },
              ),
            ),
          );
          if (newStore != null) {
            setState(() {

            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}