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