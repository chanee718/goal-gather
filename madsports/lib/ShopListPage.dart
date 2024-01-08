import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/store_model.dart';
import 'dart:io';

import 'add_store_screen.dart';


class ShopListPage extends StatefulWidget {
  ShopListPage({super.key});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}


class _ShopListPageState extends State<ShopListPage> {
  List<Store> stores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stores'),
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: stores[index].image != null
                ? Image.file(
              File(stores[index].image!),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : Container(),
            title: Text(stores[index].menu),
            subtitle: Text('Projector: ${stores[index].hasProjector}, Capacity: ${stores[index].capacity}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 가게 등록 화면으로 이동하고 등록된 가게를 리스트에 추가
          Store? newStore = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStoreScreen(
                onStoreAdded: (store) {
                  setState(() {
                    stores.add(store);
                  });
                },
              ),
            ),
          );
          if (newStore != null) {
            setState(() {
              stores.add(newStore);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}