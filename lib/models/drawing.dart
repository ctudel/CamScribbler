class Drawing {
  const Drawing({
    this.id,
    this.rgbEnabled,
    required this.title,
    required this.date,
    required this.bgPath,
    required this.drawingPath,
    required this.drawables,
  });

  final int? id;
  final int? rgbEnabled;
  final String title;
  final String date;
  final String bgPath;
  final String drawingPath;
  final String drawables;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map["id"] = id;
    map["rgb_enabled"] = rgbEnabled;
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
      rgbEnabled: drawing["rgb_enabled"],
      title: drawing["title"],
      date: drawing["date"],
      bgPath: drawing["bg_path"],
      drawingPath: drawing["drawing_path"],
      drawables: drawing["drawables"],
    );
  }
}
