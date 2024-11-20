class Drawing {
  const Drawing({
    required this.id,
    required this.title,
    required this.date,
    required this.path,
    required this.drawables,
  });

  final int id;
  final String title;
  final DateTime date;
  final String path;
  final String drawables;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["id"] = id;
    map["title"] = title;
    map["date"] = date;
    map["path"] = path;
    map["drawables"] = drawables;
    return map;
  }

  factory Drawing.fromMap(Map<String, dynamic> drawing) {
    return Drawing(
      id: drawing["id"],
      title: drawing["title"],
      date: drawing["date"],
      path: drawing["path"],
      drawables: drawing["drawables"],
    );
  }
}
