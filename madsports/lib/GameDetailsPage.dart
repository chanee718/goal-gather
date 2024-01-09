import 'package:flutter/material.dart';
import 'package:madsports/add_chat_room_screen.dart';
import 'package:madsports/sample_query.dart';

import 'add_store_screen.dart';
import 'chat_room_list.dart';

class GameDetailsPage extends StatefulWidget {
  final dynamic game_info;
  const GameDetailsPage({super.key, required this.game_info});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}



class _GameDetailsPageState extends State<GameDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('경기 정보')),
      body: Column(
        children: [
          // 상단 30% 영역
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              children: [
                // 왼쪽 팀 사진
                Expanded(child: Image.network(
                  widget.game_info['homeTeamImage'],
                  width: 50,
                  height: 50,
                )),
                // 경기 정보 중앙
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.game_info['homeTeamName'] + ' vs ' +widget.game_info['awayTeamName'], style: TextStyle(fontSize: 24)),
                      Text(widget.game_info['dateEvent'], style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                // 오른쪽 팀 사진
                Expanded(child: Image.network(
                  widget.game_info['awayTeamImage'],
                  width: 50,
                  height: 50,
                )),
              ],
            ),
          ),
          // 아래쪽 70% 영역 (채팅방 정보)
          Expanded(
            child: ChatRoomList(get_chat_by_game("")),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 가게 등록 화면으로 이동하고 등록된 가게를 리스트에 추가
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChatRoomScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}