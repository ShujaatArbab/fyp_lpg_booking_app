// order_model.dart
class SupplierOrder {
  int orderId;
  String vendorName;
  String vendorPhone;
  String vendorCity;
  DateTime oDate;
  DateTime? deliveryDate;
  String status;
  String city;
  List<Item> items;

  SupplierOrder({
    required this.orderId,
    required this.vendorName,
    required this.vendorPhone,
    required this.vendorCity,
    required this.oDate,
    this.deliveryDate,
    required this.status,
    required this.city,
    required this.items,
  });

  factory SupplierOrder.fromJson(Map<String, dynamic> json) {
    return SupplierOrder(
      orderId: json['Order_id'],
      vendorName: json['VendorName'],
      vendorPhone: json['VendorPhone'],
      vendorCity: json['VendorCity'],
      oDate: DateTime.parse(json['o_date']),
      deliveryDate:
          json['delivery_date'] != null
              ? DateTime.parse(json['delivery_date'])
              : null,
      status: json['status'],
      city: json['City'],
      items:
          (json['Items'] as List)
              .map((itemJson) => Item.fromJson(itemJson))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Order_id': orderId,
      'VendorName': vendorName,
      'VendorPhone': vendorPhone,
      'VendorCity': vendorCity,
      'o_date': oDate.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'status': status,
      'City': city,
      'Items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class Item {
  String cylinderSize;
  int quantity;

  Item({required this.cylinderSize, required this.quantity});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(cylinderSize: json['CylinderSize'], quantity: json['Quantity']);
  }

  Map<String, dynamic> toJson() {
    return {'CylinderSize': cylinderSize, 'Quantity': quantity};
  }
}
