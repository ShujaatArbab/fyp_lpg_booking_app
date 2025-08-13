class SignupResponse {
  final String userid;
  final String name;
  final String phone;
  final String email;
  final String role;
  final double? longitude;
  final double? latitude;
  final String city;

  SignupResponse({
    required this.userid,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.longitude,
    this.latitude,
    required this.city,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      userid: json['userid'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
      city: json['city'],
    );
  }
}
