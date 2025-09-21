class SupplierSignupRequest {
  final String email;
  final String password;
  final String role;
  final String name;
  final String phone;
  final String city;
  final String plantName;
  final String plantCity;

  SupplierSignupRequest({
    required this.email,
    required this.password,
    this.role = "sup", // fixed role
    required this.name,
    required this.phone,
    required this.city,
    required this.plantName,
    required this.plantCity,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Password": password,
      "Role": role,
      "Name": name,
      "Phone": phone,
      "City": city,
      "PlantName": plantName,
      "PlantCity": plantCity,
    };
  }
}
