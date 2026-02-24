import 'package:hive/hive.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'log_model.g.dart';

@HiveType(typeId: 0)
class LogModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String timestamp;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String category;
  @HiveField(6)
  final String authorId;
  @HiveField(7)
  final String teamId;

  LogModel({
    this.id,
    required this.username,
    required this.title,
    required this.timestamp,
    required this.description,
    this.category = 'Pribadi',
    required this.authorId,
    required this.teamId,
  });

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      id: (map['_id'] as ObjectId?)?.oid,
      username: map['username'] ?? '',
      title: map['title'] ?? '',
      timestamp: map['timestamp'] ?? map['date'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Pribadi',
      authorId: map['authorId'] ?? 'unknown_user',
      teamId: map['teamId'] ?? 'no_team',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id != null ? ObjectId.fromHexString(id!) : ObjectId(),
      'username': username,
      'title': title,
      'timestamp': timestamp,
      'description': description,
      'category': category,
      'authorId': authorId,
      'teamId': teamId,
    };
  }
}
