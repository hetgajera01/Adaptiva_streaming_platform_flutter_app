class Category {
  final String id;
  final String name;
  final String icon;
  final String color1;
  final String color2;
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.order,
  });

  /// Create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color1: json['color1'] as String,
      color2: json['color2'] as String,
      order: json['order'] as int,
    );
  }

  /// Convert Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color1': color1,
      'color2': color2,
      'order': order,
    };
  }
}
