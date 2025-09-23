class VendorOrderResponse {
  final String message;
  final int orderId;
  final String vendorId;
  final String supplierId;
  final String orderDate;
  final String deliveryDate;
  final String status;
  final List<OrderItemResponse> items;

  VendorOrderResponse({
    required this.message,
    required this.orderId,
    required this.vendorId,
    required this.supplierId,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.items,
  });

  factory VendorOrderResponse.fromJson(Map<String, dynamic> json) {
    return VendorOrderResponse(
      message: json['Message'],
      orderId: json['OrderId'],
      vendorId: json['VendorId'],
      supplierId: json['SupplierId'],
      orderDate: json['OrderDate'],
      deliveryDate: json['DeliveryDate'],
      status: json['Status'],
      items:
          (json['Items'] as List)
              .map((e) => OrderItemResponse.fromJson(e))
              .toList(),
    );
  }
}

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
