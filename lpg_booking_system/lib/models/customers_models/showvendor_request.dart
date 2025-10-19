class VendorRequest {
  final String city;
  VendorRequest({required this.city});
  Map<String, dynamic> toJson() => {'City': city};
}
