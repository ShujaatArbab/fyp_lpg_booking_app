class OrderTrackingRequest {
  int orderId;
  String deliveryPersonName;
  double latitude;
  double longitude;

  OrderTrackingRequest({
    required this.orderId,
    required this.deliveryPersonName,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "deliveryPersonName": deliveryPersonName,
    "latitude": latitude,
    "longitude": longitude,
  };
}
