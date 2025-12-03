class CustomerOrderItem {
  final int oiId;
  final int quantity;
  final int cyId;
  final String cylinderType;

  CustomerOrderItem({
    required this.oiId,
    required this.quantity,
    required this.cyId,
    required this.cylinderType,
  });

  factory CustomerOrderItem.fromJson(Map<String, dynamic> json) {
    return CustomerOrderItem(
      oiId: json['OI_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      cyId: json['cy_id'] ?? 0,
      cylinderType: json['CylinderType'] ?? '',
    );
  }
}

class CustomerOrders {
  final int orderId;
  final String buyerName;
  final String sellerName;
  final DateTime oDate;
  final String? deliveryDate;
  final String status;
  final String? city;
  final dynamic? price;
  final List<CustomerOrderItem> items;

  CustomerOrders({
    required this.orderId,
    required this.buyerName,
    required this.sellerName,
    required this.oDate,
    this.deliveryDate,
    required this.status,
    this.city,
    this.price,
    required this.items,
  });

  factory CustomerOrders.fromJson(Map<String, dynamic> json) {
    return CustomerOrders(
      orderId: json['Order_id'],
      buyerName: json['BuyerName'],
      sellerName: json['SellerName'],
      oDate: DateTime.parse(json['o_date']),
      deliveryDate: json['delivery_date']?.toString(),
      status: json['status'],
      city: json['City'],
      price: json['price'],
      items:
          (json['Items'] as List<dynamic>)
              .map((item) => CustomerOrderItem.fromJson(item))
              .toList(),
    );
  }
}
