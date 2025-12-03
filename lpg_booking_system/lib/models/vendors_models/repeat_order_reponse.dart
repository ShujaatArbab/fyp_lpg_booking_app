class VendorRepeatOrderResponse {
  final int orderId;
  final String orderDate;
  final String? deliveryDate;
  final String status;
  final String city;
  final int? price;
  final Buyer buyer;
  final Seller seller;
  final List<OrderItem> items;

  VendorRepeatOrderResponse({
    required this.orderId,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.city,
    this.price,
    required this.buyer,
    required this.seller,
    required this.items,
  });

  factory VendorRepeatOrderResponse.fromJson(Map<String, dynamic> json) {
    return VendorRepeatOrderResponse(
      orderId: json['OrderId'],
      orderDate: json['OrderDate'],
      deliveryDate: json['DeliveryDate'],
      status: json['Status'],
      city: json['City'],
      price: json['Price'],
      buyer: Buyer.fromJson(json['Buyer']),
      seller: Seller.fromJson(json['Seller']),
      items:
          (json['Items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
    );
  }
}

class Buyer {
  final String id;
  final String name;
  final String phone;
  final String city;

  Buyer({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['Id'],
      name: json['Name'],
      phone: json['Phone'],
      city: json['City'],
    );
  }
}

class Seller {
  final String id;
  final String name;
  final String phone;
  final String city;

  Seller({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['Id'],
      name: json['Name'],
      phone: json['Phone'],
      city: json['City'],
    );
  }
}

class OrderItem {
  final int stockId;
  final int quantity;
  final int oiId;

  OrderItem({
    required this.stockId,
    required this.quantity,
    required this.oiId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      stockId: json['stock_id'],
      quantity: json['quantity'],
      oiId: json['OI_id'],
    );
  }
}
