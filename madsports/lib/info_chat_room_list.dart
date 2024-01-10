import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/dial_phone_widget.dart';
import 'package:madsports/edit_chat_room_screen.dart';
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

  @override
  void initState() {
    super.initState();
    isJoined = false;
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

    // 상태 업데이트를 위해 setState 호출
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room Details"),
        actions: <Widget>[
          widget.ChatRoom['creator_email'] == widget.email? IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditChatRoomScreen(
                    ChatRoom: widget.ChatRoom,
                    onUpdate: () {
                      setState(() {});
                    },
                  ),
                ),
              );
              setState(() {

              });
              // 버튼
              // 이 눌렸을 때 수행할 작업
            },
          ) : Container(),
        ],
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
                  Text(
                      widget.ChatRoom['reserved_store_name'] == null ? "예약된 식당: 없음" : "예약된 식당: ${widget.ChatRoom['reserved_store_name']}",
                      style: TextStyle(fontSize: 16)
                  ),
                  Text(
                      widget.ChatRoom['reserved_address'] == null ? "예약된 식당 주소: 없음" : "예약된 식당 주소: ${widget.ChatRoom['reserved_address']}",
                      style: TextStyle(fontSize: 16)
                  ),
                  widget.ChatRoom['reserved_number'] == null ? Container() : DialPhoneWidget(phoneNumber: widget.ChatRoom['reserved_number'])
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
