import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/dial_phone_widget.dart';
import 'dart:io';

import 'package:madsports/hyperlinkwidget.dart';
import 'package:madsports/temp_classes.dart';

import 'functions.dart';

class InfoChatRoomScreen extends StatefulWidget {
  final dynamic ChatRoom;
  final String email;
  final Function() onUpdate;
  InfoChatRoomScreen({super.key, required this.ChatRoom, required this.email, required this.onUpdate});

  @override
  State<InfoChatRoomScreen> createState() => _InfoChatRoomScreenState();
}

class _InfoChatRoomScreenState extends State<InfoChatRoomScreen> {
  late bool isJoined;
  late String? store_name;
  late String? store_num;

  @override
  void initState() {
    super.initState();
    isJoined = false;
    store_name = null;
    store_num = null;
    _initializeAsyncData();
  }

  Future<void> _initializeAsyncData() async {
    dynamic list_mem = await getChatMember(widget.ChatRoom['id']);
    for (int i = 0; i < list_mem.length; i++) {
      if (list_mem[i]['user_email'] == widget.email) {
        isJoined = true;
        break;
      }
    }

    if (widget.ChatRoom['reserved_store_id'] != null && widget.ChatRoom['reserved_store_id'] != "") {
      dynamic store_inf = await findStore(widget.ChatRoom['reserved_store_id']);
      store_name = store_inf['store_name'];
      store_num = store_inf['number'] != null && store_inf['number'] != "" ? store_inf['number'] : null;
    }

    // 상태 업데이트를 위해 setState 호출
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room Details"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4, // 상단 40%
            child: Image.file(
              File(widget.ChatRoom['chat_image']), // 채팅방 사진 URL
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 6, // 하단 60%
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Chat Room Name : ${widget.ChatRoom['chat_name']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Location: ${widget.ChatRoom['region']}", style: TextStyle(fontSize: 16)),
                  Text("Join Conditions: ${widget.ChatRoom['partici_auth']}", style: TextStyle(fontSize: 16)),
                  HyperlinkWidget(url: widget.ChatRoom['chat_link'], text: "Chat Room Link"),
                  Text("Members: ${widget.ChatRoom['capacity']}", style: TextStyle(fontSize: 16)),
                  store_name != null? Text("Reserved Store: ${store_name}", style: TextStyle(fontSize: 16)):Container(),
                  store_name != null && store_num != null ? DialPhoneWidget(phoneNumber: store_num!):Container(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  isJoined = !isJoined;
                  if(isJoined == true){
                    await joinChat(widget.email, widget.ChatRoom['id']);
                  }
                  else{
                    await goOutChat(widget.email, widget.ChatRoom['id']);
                  }
                  widget.onUpdate();
                  setState(() {

                  });
                },
                child: Text(isJoined ? "Leave Chat Room" : "Join Chat Room"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
