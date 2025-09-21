class SupplierRequest {
  final String city;
  final String role;

  SupplierRequest({required this.city, required this.role});

  Map<String, dynamic> toJson() {
    return {"City": city, "Role": role};
  }
}
