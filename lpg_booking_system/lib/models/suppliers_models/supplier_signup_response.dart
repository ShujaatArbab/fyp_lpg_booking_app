class SupplierSignupResponse {
  final String message;
  final SupplierData? data;

  SupplierSignupResponse({required this.message, this.data});

  factory SupplierSignupResponse.fromJson(Map<String, dynamic> json) {
    return SupplierSignupResponse(
      message: json['message'],
      data: json['data'] != null ? SupplierData.fromJson(json['data']) : null,
    );
  }
}

class SupplierData {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String role;
  final int plantId;
  final String plantName;
  final String plantCity;

  SupplierData({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.role,
    required this.plantId,
    required this.plantName,
    required this.plantCity,
  });

  factory SupplierData.fromJson(Map<String, dynamic> json) {
    return SupplierData(
      userId: json['userid'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      city: json['city'],
      role: json['role'],
      plantId: json['plantid'],
      plantName: json['plantname'],
      plantCity: json['plantcity'],
    );
  }
}
