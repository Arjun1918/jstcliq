class ServiceModel {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final double cost;

  ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.cost,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imagePath': imagePath,
      'cost': cost,
    };
  }

  // Create from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      imagePath: json['imagePath'] ?? '',
      cost: (json['cost'] ?? 0.0).toDouble(),
    );
  }

  // Create a copy with updated fields
  ServiceModel copyWith({
    String? id,
    String? name,
    String? category,
    String? imagePath,
    double? cost,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      cost: cost ?? this.cost,
    );
  }

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, category: $category, imagePath: $imagePath, cost: $cost)';
  }
}