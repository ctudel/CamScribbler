class Drawing {
  const Drawing({
    this.id,
    required this.title,
    required this.date,
    required this.bgPath,
    required this.drawingPath,
    required this.drawables,
    this.rgbEnabled,
  });

  final int? id;
  final String title;
  final String date;
  final String bgPath;
  final String drawingPath;
  final String drawables;
  final bool? rgbEnabled;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["id"] = id;
    map["title"] = title;
    map["date"] = date;
    map["bg_path"] = bgPath;
    map["drawing_path"] = drawingPath;
    map["drawables"] = drawables;
    return map;
  }

  factory Drawing.fromMap(Map<String, dynamic> drawing) {
    return Drawing(
      id: drawing["id"],
      title: drawing["title"],
      date: drawing["date"],
      bgPath: drawing["bg_path"],
      drawingPath: drawing["drawing_path"],
      drawables: drawing["drawables"],
    );
  }
}
