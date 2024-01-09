import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'AuthService.dart';

const baseUrl = 'http://172.10.7.43:80';

// input: user의 이메일 (AuthService에서 빼서 주면 됨)
// output: user의 데이터 - user_name, profile_image, user_type
Future<dynamic> findUserwithMail(String email) async {
  final url = Uri.parse('$baseUrl/users?email=$email');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

// 유저 기본 정보 추가 기입
// input: email, username, profileImage, userType
// output 없음
// Image의 타입이 URI인지 String인지 모르겠어서 일단 String...
Future<void> editUserinfo(String email, String name, String? Image, String userType) async {
  final url = Uri.parse('$baseUrl/auth/user-edit');
  try {
    var res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': name,
          'profileImage': Image,
          'userType': userType,
        })
    );

    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('User info updated successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error updating user info. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    // HTTP 요청 실패 또는 기타 오류
    print('Error: $e');
  }
}

// 유저의 관심 팀 업데이트
// input: email - 로그인된 유저의 이메일, TeamList - 수정 완료한 관심 팀의 List
// output: 없음
Future<void> updatePreferTeam(String email, List<int> teamList) async {
  final url = Uri.parse('$baseUrl/auth/prefer-teams');
  try {
    var res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'preferTeamList': teamList,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Prefer Team updated successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error updating prefer team. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 새로운 채팅방을 생성 -- img와 link의 타입이 뭐가 맞는지 모르겠다
// input: email, game, name, img, region, capacity, auth, link
// output: 없음
Future<void> createNewChat(String email, int game, String name, String? img, String region, int capacity, String? auth, String link) async {
  final url = Uri.parse('$baseUrl/chat/newchat');
  try {
    var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'game': game,
          'name': name,
          'img': img,
          'region': region,
          'capacity': capacity,
          'auth': auth,
          'link': link,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('New Chat created successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error creating new chat. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 특정 경기의 채팅 목록 받아오기
// input: game의 id
// output: Map<String, dynamic> -> 채팅방 정보의 list
// data[i]['원하는 정보 이름'] -> (i-1) 번째 채팅방의 정보
Future<dynamic> findChatsbyGame(int id) async {
  final url = Uri.parse('$baseUrl/chat/findchat?id=$id');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

// 식당 예약하면 업데이트
// input: chatid, storeid, time (00:00 형식)
// 식당 선택 페이지로 넘어올 때 chatid랑 storeid를 계속 넘겨줘야 할듯..!
// output: 없음
Future<void> makeReservation(int chatId, String storeId, String time) async {
  final url = Uri.parse('$baseUrl/chat/reservation');
  try {
    var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chatid': chatId,
          'storeid': storeId,
          'time': time,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Reserved successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error making reservation. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 방장인지 확인
// input: chatId, userEmail
// output: 방장이면 true, 아니면 false
Future<dynamic> checkCreate(int chatId, String userEmail) async {
  final url = Uri.parse('$baseUrl/chat/checkOwner?chatId=$chatId&userEmail=$userEmail');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data['isOwner'];
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 채팅방에 참여 중인 유저들의 목록 가져오기
// input: chatId
// output: email, name의 목록  (data[i]['user_email / user_name'] -> (i-1) 번째 유저 정보)
Future<dynamic> getChatMember(int chatId) async {
  final url = Uri.parse('$baseUrl/chat/members?chatId=$chatId');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 채팅방 업데이트 - 마찬가지로 img, link 타입 의문
// input: chatid, name, img, region, capacity, auth, link
// 채팅방의 id와, 새로 수정되는 채팅방의 정보들을 기입
// 수정하지 않으면 기존의 데이터를 parameter로 넣어줘야 한다!!
// output: 없음
Future<void> updateChat(int chatid, String name, String? img, String region, int capacity, String? auth, String link) async {
  final url = Uri.parse('$baseUrl/chat/updatechat');
  try {
    var res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chatid': chatid,
          'name': name,
          'img': img,
          'region': region,
          'capacity': capacity,
          'auth': auth,
          'link': link,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Chat updated successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error updating chat. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 특정 유저가 채팅방에 참여
// input: email, chatid
// output: X
Future<void> joinChat(String email, int chatid) async {
  final url = Uri.parse('$baseUrl/chat/joinchat');
  try {
    var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chatid': chatid,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Joined to chat successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error joining chat. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 채팅방에서 나감
// input: email, chatid
// output: X
Future<void> goOutChat(String email, int chatid) async {
  final url = Uri.parse('$baseUrl/chat/getout');
  try {
    var res = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email' : email,
        'chatid': chatid,
      })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Get out of Chat successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error exiting chat. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 채팅방 삭제
// input: chatid
// output: X
Future<void> deleteChat(int chatid) async {
  final url = Uri.parse('$baseUrl/chat/deletechat');
  try {
    var res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'chatid': chatid,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Get out of Chat successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error exiting chat. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 가게 이름으로 음식점 찾기 (가게 등록할 때 쓸 것)
// input: findkey (검색창에 검색하는 이름)
// output: id(장소 고유 id), place_name(가게 이름), number(전화번호), address(도로명 주소)
Future<dynamic> findStorewithName(String findkey) async {
  final url = Uri.parse('$baseUrl/store/findwithname?findkey=$findkey');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 채팅방에 적힌 지역에 있는 음식점을 찾아줌
// input: chatid
// output: id(장소 id), place_name (가게 이름), number (가게 전화번호), category(가게 종류)
// 카카오에서 id로 장소를 찾는 기능을 지원하지 않음!
Future<dynamic> listofRestaurant(int chatid) async {
  final url = Uri.parse('$baseUrl/chat/findrestaurants?chatId=$chatid');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 가게를 DB에 추가
// input: storeid, name, image, menu, screen, capacity, owner (유저 email)
// output: X
// 가게 추가 창에서 가게를 선택하면 id와 name을 모두 가져와서 parameter로 넣어줘야 함!
Future<void> addStore(String storeid, String name, String? image, String menu, String screen, int capacity, String email) async {
  final url = Uri.parse('$baseUrl/chat/addstore');
  try {
    var res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'storeid': storeid,
          'name': name,
          'image': image,
          'menu': menu,
          'screen': screen,
          'capacity': capacity,
          'owner': email,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Add Store successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error adding store. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// DB에 등록된 가게의 정보를 수정
// input: storeid, img, menu, screen, capacity
// output: X
Future<void> updateStore(String storeid, String? image, String menu, String screen, int capacity) async {
  final url = Uri.parse('$baseUrl/chat/updatestore');
  try {
    var res = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'storeid': storeid,
          'img': image,
          'menu': menu,
          'screen': screen,
          'capacity': capacity,
        })
    );
    if (res.statusCode == 200) {
      // 성공적으로 업데이트 됐을 때의 로직
      print('Update Store successfully');
    } else {
      // 서버에서 오류 응답이 온 경우
      print('Error updating store. Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// DB에 들어있는 store인지 확인
// input: storeId
// output: DB에 들어있으면 true, DB에 없으면 false
Future<dynamic> containedDB(String storeID) async {
  final url = Uri.parse('$baseUrl/store/indb?storeId=$storeID');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data['containDB'];
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 유저 소유의 가게를 불러오는 기능
// input: email
// output: store 데이터 목록
Future<dynamic> findMyStore(String email) async {
  final url = Uri.parse('$baseUrl/store/mystore?email=$email');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 특정 날짜의 축구 경기들을 불러오는 기능
// input: date (0000-00-00 의 string 형식 - 포맷팅 필요)
// output: dateEvent(경기 날짜), homeTeamName, homeTeamImage, awayTeamName, awayTeamImage
Future<dynamic> findGamebyDate(String date) async {
  final url = Uri.parse('$baseUrl/game/gameindate?date=$date');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 관심 팀 설정할 때 팀 검색하는 기능
// input: keyword (검색창에 입력된 키워드)
// output: id (팀 고유 id), team_name, team_image (로고), league (소속 리그)
Future<dynamic> searchTeams(String? keyword) async {
  final url = Uri.parse('$baseUrl/team/allteam?keyword=$keyword');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}

// 특정 유저의 관심 팀 목록 불러오기
// input: email
// output: team 목록 [id (팀 고유 id), team_name, team_image (로고), league (소속 리그)]
Future<dynamic> preferTeams(String email) async {
  final url = Uri.parse('$baseUrl/team/preferteam?email=$email');
  try {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      return data;
    } else {
      print('서버로부터 오류 응답. Status Code: ${res.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
  }
}