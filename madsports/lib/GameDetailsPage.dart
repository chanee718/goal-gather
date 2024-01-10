

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
      appBar: AppBar(title: Text('경기 정보')),
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Row(
                    children: [
                      Expanded(child: Image.network(widget.game_info['homeTeamImage'], width: 50, height: 50)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.game_info['homeTeamName'] + ' vs ' + widget.game_info['awayTeamName'], style: TextStyle(fontSize: 24)),
                            Text(widget.game_info['startTime'], style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Expanded(child: Image.network(widget.game_info['awayTeamImage'], width: 50, height: 50)),
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
                            subtitle: Text('Reserved: ${chatRooms[index]['reserve_time'] == '' ? "No" : "Yes"}'),
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
      ),
    );
  }
}