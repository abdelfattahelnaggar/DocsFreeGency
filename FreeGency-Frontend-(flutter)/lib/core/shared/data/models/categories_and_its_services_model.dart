class ServiceModel {
  final String id;
  final String name;
  final String image;

  ServiceModel({
    required this.id,
    required this.name,
    required this.image,
  });

  // Factory constructor to create Service from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String status;
  final List<ServiceModel> services;
  final int servicesCount;
  final String color;
  final String? image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.status,
    required this.services,
    required this.servicesCount,
    required this.color,
    required this.image,
  });

  // Factory constructor to create Category from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<ServiceModel> services = [];

    // Safely handle services list
    if (json['services'] != null) {
      var serviceList = json['services'] as List;
      services = serviceList
          .map((i) => ServiceModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'active',
      services: services,
      servicesCount: json['servicesCount'] ?? 0,
      color: json['color'] ?? '#FFFFFF',
      image: json['imageCover'],
    );
  }
}

class CategoriesAndItsServicesModel {
  final String message;
  final List<CategoryModel> data;

  CategoriesAndItsServicesModel({
    required this.message,
    required this.data,
  });

  // Factory constructor to create ApiResponse from JSON
  factory CategoriesAndItsServicesModel.fromJson(Map<String, dynamic> json) {
    var categoryList = json['data'] as List;
    List<CategoryModel> categories = categoryList
        .map((i) => CategoryModel.fromJson(i as Map<String, dynamic>))
        .toList();

    return CategoriesAndItsServicesModel(
      message: json['message'],
      data: categories,
    );
  }
}
