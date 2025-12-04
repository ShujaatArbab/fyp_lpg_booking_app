class OrderDetailsResponse {
  final int orderId;
  final Buyer buyer;
  final Seller seller;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String status;
  final double latitude;
  final double longitude;
  final List<OrderItem> items;

  OrderDetailsResponse({
    required this.orderId,
    required this.buyer,
    required this.seller,
    required this.orderDate,
    required this.deliveryDate,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.items,
  });

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResponse(
      orderId: json['OrderId'],
      buyer: Buyer.fromJson(json['Buyer']),
      seller: Seller.fromJson(json['Seller']),
      orderDate: DateTime.parse(json['OrderDate']),
      deliveryDate:
          json['DeliveryDate'] != null
              ? DateTime.parse(json['DeliveryDate'])
              : null,
      status: json['Status'],
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),

      items: (json['Items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
    );
  }
}

class Buyer {
  final String id;
  final String name;
  final String city;

  Buyer({required this.id, required this.name, required this.city});

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(id: json['Id'], name: json['Name'], city: json['City']);
  }
}

class Seller {
  final String id;
  final String name;
  final String phone;
  final String city;
  final String address;

  Seller({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['Id'],
      name: json['Name'],
      phone: json['Phone'],
      city: json['City'],
      address: json['Address'],
    );
  }
}

class OrderItem {
  final String cylinderType;
  final int quantity;
  final List<String> accessories;

  OrderItem({
    required this.cylinderType,
    required this.quantity,
    required this.accessories,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      cylinderType: json['CylinderType'],
      quantity: json['Quantity'],
      accessories:
          (json['Accessories'] as List).map((e) => e.toString()).toList(),
    );
  }
}
