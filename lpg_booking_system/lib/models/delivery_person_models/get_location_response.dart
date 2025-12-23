class OrderLocation {
  final double latitude;
  final double longitude;
  final String deliveryPersonName;
  final DateTime createdAt;

  OrderLocation({
    required this.latitude,
    required this.longitude,
    required this.deliveryPersonName,
    required this.createdAt,
  });

  factory OrderLocation.fromJson(Map<String, dynamic> json) {
    return OrderLocation(
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      deliveryPersonName: json['DeliveryPersonName'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}
