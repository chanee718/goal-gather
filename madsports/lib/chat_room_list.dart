import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:madsports/temp_classes.dart';

import 'edit_chat_room_screen.dart';
/*
class ChatRoomList extends StatelessWidget {

  List<ChatRoom> chatRooms;

  ChatRoomList(this.chatRooms);


  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: chatRooms.length,
      itemBuilder: (context, index) => ChatRoomItem(chatRooms[index]),
    );
  }
}

class ChatRoomItem extends StatelessWidget {
  final ChatRoom chatRoom;

  ChatRoomItem(this.chatRoom);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Image.asset(
        chatRoom.image,
        width: 10,
        height: 10,
      ),
      title: Text(chatRoom.name),
      subtitle: Text('${chatRoom.location}, ${chatRoom.joinCondition}'),
      children: [
        // 채팅방 참여 조건과 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('참여 조건: ${chatRoom.joinCondition}'),
            ElevatedButton(
              onPressed: () {
                // 채팅방 참여 여부 토글 로직 구현
              },
              child: Text(chatRoom.isJoined ? '참여 중' : '참여하기'),
            ),
          ],
        ),
        // 채팅방 정보 수정 버튼
        ElevatedButton(
          onPressed: () {
            // 채팅방 정보 수정 화면으로 이동
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EditChatRoomScreen(chatRoom),
            //   ),
            // );
          },
          child: Text('채팅방 수정'),
        ),
      ],
    );
  }
}

 */