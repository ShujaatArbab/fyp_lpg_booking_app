class VendorResponse {
  final String userID;
  final String name;
  final String phone;
  final String email;
  final double? longitude;
  final double? latitude;
  final String city;
  VendorResponse({
    required this.city,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.phone,
    required this.userID,
  });
  factory VendorResponse.fromJson(Map<String, dynamic> json) {
    return VendorResponse(
      city: json['City'] ?? '',
      email: json['Email'] ?? '',
      latitude: (json['Latitude'] as num?)?.toDouble(),
      longitude: (json['Longitude'] as num?)?.toDouble(),
      name: json['Name'] ?? '',
      phone: json['Phone'] ?? '',
      userID: json['UserID'].toString(),
    );
  }
}
