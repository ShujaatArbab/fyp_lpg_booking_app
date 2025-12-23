class OrderTrackingResponse {
  double latitude;
  double longitude;
  String deliveryPersonName;
  DateTime createdAt;

  OrderTrackingResponse({
    required this.latitude,
    required this.longitude,
    required this.deliveryPersonName,
    required this.createdAt,
  });

  factory OrderTrackingResponse.fromJson(Map<String, dynamic> json) {
    return OrderTrackingResponse(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      deliveryPersonName: json['deliveryPersonName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
