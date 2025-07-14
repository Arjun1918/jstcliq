
class ElectricalShop {
  final String id;
  final String name;
  final String details;
  final String timings;
  final String location;
  final String distance;
  final String imageUrl;
  final List<ElectricalService> services;

  ElectricalShop({
    required this.id,
    required this.name,
    required this.details,
    required this.timings,
    required this.location,
    required this.distance,
    required this.imageUrl,
    required this.services,
  });

  factory ElectricalShop.fromJson(Map<String, dynamic> json) {
    return ElectricalShop(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      timings: json['timings'] ?? '',
      location: json['location'] ?? '',
      distance: json['distance'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      services: (json['services'] as List<dynamic>?)
          ?.map((service) => ElectricalService.fromJson(service))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'timings': timings,
      'location': location,
      'distance': distance,
      'imageUrl': imageUrl,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}

class ElectricalService {
  final String id;
  final String name;
  final double cost;
  final String description;
  final bool isAvailable;

  ElectricalService({
    required this.id,
    required this.name,
    required this.cost,
    required this.description,
    this.isAvailable = true,
  });

  String get formattedCost => 'Cost : Rs ${cost.toInt()}';

  factory ElectricalService.fromJson(Map<String, dynamic> json) {
    return ElectricalService(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cost: (json['cost'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'description': description,
      'isAvailable': isAvailable,
    };
  }
}