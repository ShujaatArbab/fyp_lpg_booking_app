class AssignDeliveryPersonRequest {
  final int orderId;
  final String deliveryPerson;

  AssignDeliveryPersonRequest({
    required this.orderId,
    required this.deliveryPerson,
  });

  Map<String, dynamic> toJson() => {
    "Order_id": orderId,
    "delivery_person": deliveryPerson,
  };
}
