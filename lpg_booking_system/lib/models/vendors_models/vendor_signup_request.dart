class VendorSignupRequest {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String city;
  final String role;
  final String shopName;
  final String shopCity;

  VendorSignupRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.city,
    required this.role,
    required this.shopName,
    required this.shopCity,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Phone": phone,
      "Email": email,
      "Password": password,
      "City": city,
      "Role": role,
      "ShopName": shopName,
      "ShopCity": shopCity,
    };
  }
}
