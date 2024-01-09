import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InfoChatRoomScreen extends StatefulWidget {
  final dynamic ChatRoom;
  final String email;
  final Function() onUpdate;
  InfoChatRoomScreen({super.key, required this.ChatRoom, required this.email, required this.onUpdate});

  @override
  State<InfoChatRoomScreen> createState() => _InfoChatRoomScreenState();
}

class _InfoChatRoomScreenState extends State<InfoChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
