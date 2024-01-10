import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperlinkWidget extends StatelessWidget {
  final String url;
  final String text;

  HyperlinkWidget({super.key, required this.url, required this.text});

  Future<void> _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchURL,
      child: Text(
        text,
        style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
      ),
    );
  }
}