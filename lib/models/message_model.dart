class MessageModel {
  final int? id;
  final String sender;
  final String text;
  final int timestamp;
  final int isDeleted; // 0 = false, 1 = true

  MessageModel({
    this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isDeleted = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
      'isDeleted': isDeleted,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      sender: map['sender'],
      text: map['text'],
      timestamp: map['timestamp'],
      isDeleted: map['isDeleted'],
    );
  }
}
