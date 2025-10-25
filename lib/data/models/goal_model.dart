import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/goal_entity.dart';

class GoalModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String categoryId;
  final String priority;
  final String status;
  final DateTime targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final Map<String, dynamic>? metadata;

  const GoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.priority,
    required this.status,
    required this.targetDate,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.metadata,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      categoryId: json['categoryId'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      targetDate: (json['targetDate'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'priority': priority,
      'status': status,
      'targetDate': Timestamp.fromDate(targetDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
      'metadata': metadata,
    };
  }

  factory GoalModel.fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      categoryId: entity.categoryId,
      priority: entity.priority,
      status: entity.status,
      targetDate: entity.targetDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      tags: entity.tags,
      metadata: entity.metadata,
    );
  }

  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      userId: userId,
      title: title,
      description: description,
      categoryId: categoryId,
      priority: priority,
      status: status,
      targetDate: targetDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      metadata: metadata,
    );
  }

  GoalModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? categoryId,
    String? priority,
    String? status,
    DateTime? targetDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }
}
