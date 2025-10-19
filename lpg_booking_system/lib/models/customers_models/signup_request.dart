class SignupRequest {
  final String name;
  final String phone;
  final String email;
  final String city;
  final String password;
  final String role;

  SignupRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.password,
    required this.role,
  });
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Phone': phone,
      'Email': email,
      'City': city,
      'Password': password,
      'Role': role,
    };
  }
}
