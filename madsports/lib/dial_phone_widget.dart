import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DialPhoneWidget extends StatelessWidget {
  // 전화번호
  final String phoneNumber;
  DialPhoneWidget({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _makePhoneCall(phoneNumber),
        child: Text('전화 걸기'),
      ),
    );
  }

  // 전화 걸기 함수
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw '전화를 걸 수 없습니다: $phoneNumber';
    }
  }
}