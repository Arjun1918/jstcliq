import 'package:kods/services/modules/electrician/model/electrician_model.dart';

class ElectricalDataService {
  static final List<ElectricalShop> _mockData = [
    ElectricalShop(
      id: '1',
      name: 'SRI MATHA ELECTRICAL',
      details: 'Professional electrical services with experienced technicians',
      timings: '9:00 AM - 8:00 PM',
      location: 'R R NAGAR',
      distance: '500m',
      imageUrl: 'assets/images/electric.png',
      services: [
        ElectricalService(
          id: 's1',
          name: 'General Service',
          cost: 350,
          description: 'General electrical maintenance and repair',
        ),
        ElectricalService(
          id: 's2',
          name: 'Electrical Consultancy',
          cost: 250,
          description: 'Professional electrical consultation',
        ),
        ElectricalService(
          id: 's3',
          name: 'Wiring & Cables',
          cost: 450,
          description: 'Complete wiring and cable installation',
        ),
        ElectricalService(
          id: 's4',
          name: 'Appliance Repair',
          cost: 300,
          description: 'Home appliance repair and maintenance',
        ),
      ],
    ),
    ElectricalShop(
      id: '2',
      name: 'SRI MATHA ELECTRICAL',
      details: 'Reliable electrical solutions for homes and offices',
      timings: '8:00 AM - 7:00 PM',
      location: 'R R NAGAR',
      distance: '1.2km',
      imageUrl: 'assets/images/electric.png',
      services: [
        ElectricalService(
          id: 's5',
          name: 'General Service',
          cost: 320,
          description: 'General electrical maintenance and repair',
        ),
        ElectricalService(
          id: 's6',
          name: 'Emergency Service',
          cost: 500,
          description: '24/7 emergency electrical service',
        ),
        ElectricalService(
          id: 's7',
          name: 'Installation Service',
          cost: 400,
          description: 'New electrical installation work',
        ),
        ElectricalService(
          id: 's8',
          name: 'Safety Inspection',
          cost: 200,
          description: 'Complete electrical safety inspection',
        ),
      ],
    ),
    ElectricalShop(
      id: '3',
      name: 'SRI MATHA ELECTRICAL',
      details: 'Expert electrical services with quality guarantee',
      timings: '9:00 AM - 6:00 PM',
      location: 'R R NAGAR',
      distance: '2.1km',
      imageUrl: 'assets/images/electric.png',
      services: [
        ElectricalService(
          id: 's9',
          name: 'General Service',
          cost: 380,
          description: 'General electrical maintenance and repair',
        ),
        ElectricalService(
          id: 's10',
          name: 'Smart Home Setup',
          cost: 800,
          description: 'Smart home electrical automation',
        ),
        ElectricalService(
          id: 's11',
          name: 'Panel Upgrade',
          cost: 600,
          description: 'Electrical panel upgrade and maintenance',
        ),
        ElectricalService(
          id: 's12',
          name: 'Lighting Solutions',
          cost: 350,
          description: 'Custom lighting installation and design',
        ),
      ],
    ),
  ];

  static final List<ElectricalService> _dummyServices = [
    ElectricalService(
      id: 'dummy1',
      name: 'General Service',
      cost: 350,
      description: 'Complete electrical maintenance and troubleshooting for all types of electrical issues',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy2',
      name: 'Emergency Service',
      cost: 500,
      description: '24/7 emergency electrical repair service for urgent electrical problems',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy3',
      name: 'Wiring & Installation',
      cost: 450,
      description: 'New electrical wiring installation and cable management for homes and offices',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy4',
      name: 'Appliance Repair',
      cost: 300,
      description: 'Professional home appliance repair and maintenance service',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy5',
      name: 'Smart Home Setup',
      cost: 800,
      description: 'Smart home automation system installation and IoT device setup',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy6',
      name: 'Panel Upgrade',
      cost: 600,
      description: 'Electrical panel upgrade and circuit breaker installation service',
      isAvailable: false,
    ),
    ElectricalService(
      id: 'dummy7',
      name: 'Lighting Solutions',
      cost: 350,
      description: 'Custom lighting design and LED installation for residential and commercial spaces',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy8',
      name: 'Safety Inspection',
      cost: 200,
      description: 'Complete electrical safety audit and inspection with detailed report',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy9',
      name: 'Solar Installation',
      cost: 1200,
      description: 'Solar panel installation and grid connection setup for renewable energy',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy10',
      name: 'Generator Service',
      cost: 400,
      description: 'Generator installation, maintenance and repair service for backup power',
      isAvailable: false,
    ),
    ElectricalService(
      id: 'dummy11',
      name: 'Electrical Consultancy',
      cost: 250,
      description: 'Professional electrical consultation and project planning services',
      isAvailable: true,
    ),
    ElectricalService(
      id: 'dummy12',
      name: 'Motor Repair',
      cost: 320,
      description: 'Electric motor repair and maintenance for industrial and domestic use',
      isAvailable: true,
    ),
  ];

  static Future<List<ElectricalShop>> getAllElectricalShops() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData;
  }

  static Future<ElectricalShop?> getElectricalShopById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockData.firstWhere((shop) => shop.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<ElectricalShop>> searchShopsByLocation(
    String location,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockData
        .where(
          (shop) =>
              shop.location.toLowerCase().contains(location.toLowerCase()),
        )
        .toList();
  }

  static Future<List<ElectricalService>> getServicesForShop(
    String shopId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final shop = await getElectricalShopById(shopId);
    return shop?.services ?? [];
  }

  // New method to get all available electrical services (dummy data)
  static Future<List<ElectricalService>> getAllElectricalServices() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyServices;
  }

  // Method to get services by category (if needed later)
  // static Future<List<ElectricalService>> getServicesByCategory(String category) async {
  //   await Future.delayed(const Duration(milliseconds: 300));
    
  //   switch (category.toLowerCase()) {
  //     case 'basic':
  //       return _dummyServices.where((service) => 
  //         service.name.toLowerCase().contains('general') ||
  //         service.name.toLowerCase().contains('repair') ||
  //         service.name.toLowerCase().contains('maintenance')
  //       ).toList();
      
  //     case 'installation':
  //       return _dummyServices.where((service) => 
  //         service.name.toLowerCase().contains('installation') ||
  //         service.name.toLowerCase().contains('wiring') ||
  //         service.name.toLowerCase().contains('setup')
  //       ).toList();
      
  //     case 'advanced':
  //       return _dummyServices.where((service) => 
  //         service.name.toLowerCase().contains('smart') ||
  //         service.name.toLowerCase().contains('solar') ||
  //         service.name.toLowerCase().contains('automation')
  //       ).toList();
      
  //     default:
  //       return _dummyServices;
  //   }
  // }
}