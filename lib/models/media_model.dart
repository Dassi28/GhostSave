class MediaModel {
  final int? id;
  final String path;
  final String type; // 'image', 'video'
  final int timestamp;
  final String source; // 'status', 'view_once'

  MediaModel({
    this.id,
    required this.path,
    required this.type,
    required this.timestamp,
    required this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'type': type,
      'timestamp': timestamp,
      'source': source,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['id'],
      path: map['path'],
      type: map['type'],
      timestamp: map['timestamp'],
      source: map['source'],
    );
  }
}
