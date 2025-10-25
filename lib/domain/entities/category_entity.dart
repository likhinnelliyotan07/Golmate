class CategoryEntity {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.icon == icon &&
        other.color == color &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, description, icon, color, createdAt);
  }

  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name)';
  }
}
