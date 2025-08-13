class Vendor {
  final String title;
  final String city;
  final String phone;
  final String rating;

  Vendor({
    required this.title,
    required this.city,
    required this.phone,
    required this.rating,
  });
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      title: json['Name'],
      city: json['City'] ?? '',
      phone: json['Phone'] ?? '',
      rating: json['Rating']?.toString() ?? '0.0',
    );
  }
}
