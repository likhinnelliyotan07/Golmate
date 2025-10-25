class GoalEntity {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String categoryId;
  final String priority; // 'low', 'medium', 'high'
  final String status; // 'active', 'completed', 'paused', 'cancelled'
  final DateTime targetDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final Map<String, dynamic>? metadata;

  const GoalEntity({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GoalEntity &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.categoryId == categoryId &&
        other.priority == priority &&
        other.status == status &&
        other.targetDate == targetDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      title,
      description,
      categoryId,
      priority,
      status,
      targetDate,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'GoalEntity(id: $id, title: $title, status: $status)';
  }
}
