import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:madsports/store_model.dart';

class AddStoreScreen extends StatefulWidget {
  final Function(Store) onStoreAdded;

  AddStoreScreen({super.key, required this.onStoreAdded});

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  TextEditingController menuController = TextEditingController();
  TextEditingController projectorController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pickedImage != null
                ? Image.file(
              _pickedImage!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )
                : Container(),
            ElevatedButton(
              onPressed: () async {
                // 이미지 선택
                final picker = ImagePicker();
                final pickedImage = await picker.getImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _pickedImage = File(pickedImage.path);
                  });
                }
              },
              child: Text('Pick an Image'),
            ),
            TextField(
              controller: menuController,
              decoration: InputDecoration(labelText: 'Main Menu'),
            ),
            TextField(
              controller: projectorController,
              decoration: InputDecoration(labelText: 'Has Projector (true/false)'),
            ),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Capacity'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 등록 버튼을 누르면 데이터를 전달하고 화면을 닫음
                Store newStore = Store(
                  image: _pickedImage?.path,
                  menu: menuController.text,
                  hasProjector: projectorController.text.toLowerCase() == 'true',
                  capacity: int.tryParse(capacityController.text) ?? 0,
                );
                widget.onStoreAdded(newStore);
                Navigator.pop(context);
              },
              child: Text('Add Store'),
            ),
          ],
        ),
      ),
    );
  }
}