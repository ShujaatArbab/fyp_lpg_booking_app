class LoginResponse {
  final String userid;
  final String name;
  final String email;
  final String role;
  final double longitude;
  final double latitude;
  final String phone;
  final String city;
  final String password;
  LoginResponse({
    required this.userid,
    required this.name,
    required this.email,
    required this.role,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.city,
    required this.password,
  });
  //! converting  json to dart object
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userid: json['UserID'],
      name: json['Name'],
      email: json['Email'],
      role: json['Role'],
      longitude: json['Longitude']?.toDouble() ?? 0.0,
      latitude: json['Latitude']?.toDouble() ?? 0.0,
      phone: json['Phone'] ?? '',
      city: json['City'],
      password: json['Password'],
    );
  }
}
