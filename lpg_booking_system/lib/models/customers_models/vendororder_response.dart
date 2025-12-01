class Order {
  final int orderId;
  final String buyerName;
  final String buyerPhone;
  final String buyerCity;
  final String status;
  final String orderDate;
  final String? deliveryDate;
  final String city;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerCity,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    required this.city,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['Order_id'],
      buyerName: json['BuyerName'] ?? json['VendorName'] ?? "Unknown",
      buyerPhone: json['BuyerPhone'] ?? json['VendorPhone'] ?? "N/A",
      buyerCity: json['BuyerCity'] ?? json['VendorCity'] ?? "N/A",
      status: json['status'],
      orderDate: json['o_date'],
      deliveryDate: json['delivery_date'],
      city: json['City'] ?? "",
      items: (json['Items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
    );
  }

  get vendorId => null;
}

class OrderItem {
  final int quantity;
  final String cylinderSize;

  OrderItem({required this.quantity, required this.cylinderSize});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      quantity: json['Quantity'],
      cylinderSize: json['CylinderSize'] ?? "",
    );
  }
}
