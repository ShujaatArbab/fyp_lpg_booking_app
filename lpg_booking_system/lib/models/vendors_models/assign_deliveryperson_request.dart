class AssignDeliveryPersonRequest {
  final int orderId;
  final String deliveryPersonName;

  AssignDeliveryPersonRequest({
    required this.orderId,
    required this.deliveryPersonName,
  });

  Map<String, dynamic> toJson() => {
    "OrderId": orderId,
    "DeliveryPersonName": deliveryPersonName,
  };
}
