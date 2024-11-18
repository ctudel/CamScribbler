class Drawing {
  const Drawing({
    required this.id,
    required this.title,
    required this.date,
    required this.path,
  });

  final int id;
  final String title;
  final DateTime date;
  final String path;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["id"] = id;
    map["title"] = title;
    map["date"] = date;
    map["path"] = path;
    return map;
  }

  factory Drawing.fromMap(Map<String, dynamic> drawing) {
    return Drawing(
      id: drawing["id"],
      title: drawing["title"],
      date: drawing["date"],
      path: drawing["path"],
    );
  }
}
