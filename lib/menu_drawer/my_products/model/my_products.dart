class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final double cost;

  ProductModel({
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
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      imagePath: json['imagePath'] ?? '',
      cost: (json['cost'] ?? 0.0).toDouble(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? imagePath,
    double? cost,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      cost: cost ?? this.cost,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, category: $category, imagePath: $imagePath, cost: $cost)';
  }
}