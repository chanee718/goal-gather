import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  final String matchTitle;

  const GameDetailsPage({super.key, required this.matchTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matchTitle),
      ),
      body: Center(
        child: Text('Details for $matchTitle'),
      ),
    );
  }
}