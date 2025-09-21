class VendorSignupResponse {
  final String message;
  final SignupData? data;

  VendorSignupResponse({required this.message, this.data});

  factory VendorSignupResponse.fromJson(Map<String, dynamic> json) {
    return VendorSignupResponse(
      message: json["message"] ?? "",
      data: json["data"] != null ? SignupData.fromJson(json["data"]) : null,
    );
  }
}

class SignupData {
  final String userid;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String role;
  final int shopid;
  final String shopname;
  final String shopcity;

  SignupData({
    required this.userid,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.role,
    required this.shopid,
    required this.shopname,
    required this.shopcity,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      userid: json["userid"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      city: json["city"] ?? "",
      role: json["role"] ?? "",
      shopid: json["shopid"] ?? 0,
      shopname: json["shopname"] ?? "",
      shopcity: json["shopcity"] ?? "",
    );
  }
}
