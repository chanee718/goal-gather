

import 'package:madsports/temp_classes.dart';

List<String> get_game_by_date(DateTime t){
  if(t.day % 2 == 0){
    return ['SF','DFS','Hi','Good','EAT','EX1','TTT', 'd', 'd', 'd', 'd', 'd', 'd', 'd'];
  }
  return ['SF','Hh','d','sdgsdgs'];
}

List<ChatRoom> get_chat_by_game(String game){
  return [
    ChatRoom(image: "asset/image/google.png", name: "sample name 1", location: "", joinCondition: "Not You"),
    ChatRoom(image: "asset/image/naver_logo.png", name: "sample name 1", location: "dsf", joinCondition: "Not You 2"),
  ];
}

List<String> get_shop_by_position(String position){
  return["SDSD","FDSFDF","jdskfnsjdkf"];
}

