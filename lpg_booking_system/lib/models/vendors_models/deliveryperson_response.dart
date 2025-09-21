class DeliveryPerson {
  final int dpId;
  final String name;
  final String phone;
  final bool isAvailable;

  DeliveryPerson({
    required this.dpId,
    required this.name,
    required this.phone,
    required this.isAvailable,
  });

  factory DeliveryPerson.fromJson(Map<String, dynamic> json) {
    return DeliveryPerson(
      dpId: json['DPId'],
      name: json['Name'],
      phone: json['Phone'],
      isAvailable: json['IsAvailable'] ?? true,
    );
  }
}
