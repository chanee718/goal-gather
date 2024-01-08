import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  final String matchTitle;

  const GameDetailsPage({super.key, required this.matchTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 위쪽 30%에 경기 정보를 표시하는 컨테이너
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.greenAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 좌측 팀 로고 (이미지 경로나 네트워크 URL로 변경하세요)
              Image.asset(
                'asset/image/left.jpg',
                width: 50,
                height: 50,
              ),
              // 가운데에 경기 이름과 시간을 표시
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    matchTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '경기 시간: 2024-01-07 18:00',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // 우측 팀 로고 (이미지 경로나 네트워크 URL로 변경하세요)
              Image.asset(
                'asset/image/right.png',
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
        // 아래쪽 70%에는 리스트뷰로 관심있는 사람들을 표시
        Expanded(
          child: ListView.builder(
            itemCount: 10, // 예시로 10개의 아이템을 표시
            itemBuilder: (context, index) {
              return Card(
                child: ExpansionTile(
                  title: Text("Hell World! $index"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Hell! $index",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}