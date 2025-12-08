class AccessoryResponse {
  final int cylinderId;
  final String usagePurpose;
  final int quantity;

  AccessoryResponse({
    required this.cylinderId,
    required this.usagePurpose,
    required this.quantity,
  });

  factory AccessoryResponse.fromJson(Map<String, dynamic> json) {
    return AccessoryResponse(
      cylinderId: json['CylinderId'],
      usagePurpose: json['UsagePurpose'],
      quantity: json['Quantity'],
    );
  }
}

class OrderItemResponse {
  final int stockId;
  final int quantity;
  final List<AccessoryResponse> accessories;

  OrderItemResponse({
    required this.stockId,
    required this.quantity,
    required this.accessories,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      stockId: json['stock_id'],
      quantity: json['quantity'],
      accessories:
          (json['Accessories'] as List)
              .map((a) => AccessoryResponse.fromJson(a))
              .toList(),
    );
  }
}

class OrderResponse {
  final String message;
  final int orderId;
  final String buyer;
  final String seller;
  final String orderDate;
  final String? deliveryDate;
  final double latitude;
  final double longitude;
  final String status;
  final int price;
  final List<OrderItemResponse> items;

  OrderResponse({
    required this.message,
    required this.orderId,
    required this.buyer,
    required this.seller,
    required this.orderDate,
    this.deliveryDate,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.price,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      message: json['Message'],
      orderId: int.parse(json['OrderId'].toString()),
      buyer: json['Buyer'],
      seller: json['Seller'],
      orderDate: json['OrderDate'],
      deliveryDate: json['DeliveryDate']?.toString(),
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      status: json['Status'],
      price: int.parse(json['Price'].toString()),
      items:
          (json['Items'] as List)
              .map((i) => OrderItemResponse.fromJson(i))
              .toList(),
    );
  }
}
