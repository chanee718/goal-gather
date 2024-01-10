import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madsports/functions.dart';
import 'package:madsports/temp_classes.dart';
import 'dart:io';

class PrefTeamScreen extends StatefulWidget {
  final String email;
  PrefTeamScreen({super.key, required this.email});

  @override
  State<PrefTeamScreen> createState() => _PrefTeamScreenState();
}

class _PrefTeamScreenState extends State<PrefTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관심 팀'),
      ),
      body: FutureBuilder<dynamic>(
        future: preferTeams(widget.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                dynamic team = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(team['team_image']),
                    title: Text(team['team_name']),
                    subtitle: Text(team['league']),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('관심 팀 데이터가 없습니다.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 팀 추가 화면으로 이동
        },
        child: Icon(Icons.add),
        tooltip: '팀 추가',
      ),
    );
  }
}
