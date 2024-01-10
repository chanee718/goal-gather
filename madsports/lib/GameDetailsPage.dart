

import 'package:flutter/material.dart';
import 'package:madsports/add_chat_room_screen.dart';
import 'package:madsports/edit_chat_room_screen.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/info_chat_room_list.dart';
import 'dart:io';
import 'package:madsports/sample_query.dart';

import 'add_store_screen.dart';
import 'chat_room_list.dart';

class GameDetailsPage extends StatefulWidget {
  final dynamic game_info;
  final String email;
  const GameDetailsPage({super.key, required this.game_info, required this.email});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}



class _GameDetailsPageState extends State<GameDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('경기 정보', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 43, 0, 53),
          iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: findChatsbyGame(widget.game_info['game_id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            dynamic chatRooms = snapshot.data;
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 43, 0, 53),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3, // Flex를 조정하여 가운데 열이 더 넓게 보이게 함
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0), // 왼쪽 공간 조정
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(widget.game_info['homeTeamImage'], width: 60, height: 60),
                                SizedBox(height: 15),
                                Text(widget.game_info['homeTeamName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4, // 가운데 열을 더 넓게 만들기 위한 flex 값 조정
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.game_info['gameDate'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                            SizedBox(height: 15),
                            Text(widget.game_info['startTime'], style: TextStyle(fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3, // Flex를 조정하여 가운데 열이 더 넓게 보이게 함
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.0), // 오른쪽 공간 조정
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(widget.game_info['awayTeamImage'], width: 60, height: 60),
                                SizedBox(height: 15),
                                Text(widget.game_info['awayTeamName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        leading: Image.file(File(chatRooms[index]['chat_image'])),
                        title: Text(chatRooms[index]['chat_name']),
                        subtitle: Text('Location: ${chatRooms[index]['region']}'),
                        children: <Widget>[
                          ListTile(
                            title: Text('Members: ${chatRooms[index]['capacity']}'),
                            subtitle: Text('Reserved: ${chatRooms[index]['reserve_time'] == null || chatRooms[index]['reserve_time'] == ''? "No" : "Yes"}'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              chatRooms[index]['creator_email'] == widget.email ? TextButton(
                                child: Text('Chat Edit'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditChatRoomScreen(
                                        ChatRoom: chatRooms[index],
                                        onUpdate: () {
                                          setState(() {});
                                          },
                                      ),
                                    ),
                                  );
                                },
                              ) : Container(),
                              TextButton(
                                child: Text('Chat Info'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InfoChatRoomScreen(
                                        ChatRoom: chatRooms[index],
                                        email: widget.email,
                                        onUpdate: () {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No chat rooms available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChatRoomScreen(
                email: widget.email,
                game: widget.game_info['game_id'],
                onUpdate: () {
                  setState(() {});
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 72, 252, 155),
        shape: CircleBorder()
      ),
    );
  }
}