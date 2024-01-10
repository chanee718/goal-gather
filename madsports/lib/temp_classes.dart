class Store {
  String? image; // Nullable로 변경
  String menu;
  bool hasProjector;
  int capacity;

  Store({
    this.image,
    required this.menu,
    required this.hasProjector,
    required this.capacity,
  });
}

class Game {
  String leftTeamImage;
  String rightTeamImage;
  String gameName;
  String gameTime;

  Game({
    required this.leftTeamImage,
    required this.rightTeamImage,
    required this.gameName,
    required this.gameTime,
  });
}

class ChatRoom {
  String image;
  String name;
  String location;
  String joinCondition;
  bool isJoined;

  ChatRoom({
    required this.image,
    required this.name,
    required this.location,
    required this.joinCondition,
    this.isJoined = false,
  });
}