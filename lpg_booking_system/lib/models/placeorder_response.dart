class OrderItemResponse {
  final int stockId;
  final int quantity;

  OrderItemResponse({required this.stockId, required this.quantity});

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      stockId: json['stock_id'],
      quantity: json['quantity'],
    );
  }
}

class OrderResponse {
  final String message;
  final int orderId;
  final String buyer;
  final String seller;
  final String orderDate;
  final String deliveryDate;
  final double latitude;
  final double longitude;
  final String status;
  final List<OrderItemResponse> items;

  OrderResponse({
    required this.message,
    required this.orderId,
    required this.buyer,
    required this.seller,
    required this.orderDate,
    required this.deliveryDate,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      message: json['Message'],
      orderId: int.parse(json['OrderId'].toString()),
      buyer: json['Buyer'],
      seller: json['Seller'],
      orderDate: json['OrderDate'],
      deliveryDate: json['DeliveryDate'],
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      status: json['Status'],
      items:
          (json['Items'] as List)
              .map((e) => OrderItemResponse.fromJson(e))
              .toList(),
    );
  }
}
