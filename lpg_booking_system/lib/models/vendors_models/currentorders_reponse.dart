class VendorCurrentOrder {
  final int orderId;
  final String buyerName;
  final String sellerName;
  final String status;
  final String city;
  final String? price;
  final String oDate;
  final String? deliveryDate;
  final List<VendorOrderItem> items;

  VendorCurrentOrder({
    required this.orderId,
    required this.buyerName,
    required this.sellerName,
    required this.status,
    required this.city,
    this.price,
    required this.oDate,
    this.deliveryDate,
    required this.items,
  });

  factory VendorCurrentOrder.fromJson(Map<String, dynamic> json) {
    var itemsList = <VendorOrderItem>[];
    if (json['Items'] != null) {
      itemsList =
          (json['Items'] as List)
              .map((i) => VendorOrderItem.fromJson(i))
              .toList();
    }

    return VendorCurrentOrder(
      orderId: json['Order_id'],
      buyerName: json['BuyerName'] ?? '',
      sellerName: json['SellerName'] ?? '',
      status: json['status'] ?? '',
      city: json['City'] ?? '',
      price: json['price']?.toString(),
      oDate: json['o_date'] ?? '',
      deliveryDate: json['delivery_date'],
      items: itemsList,
    );
  }
}

class VendorOrderItem {
  final int oiId;
  final int quantity;
  final int cyId;
  final String cylinderType;

  VendorOrderItem({
    required this.oiId,
    required this.quantity,
    required this.cyId,
    required this.cylinderType,
  });

  factory VendorOrderItem.fromJson(Map<String, dynamic> json) {
    return VendorOrderItem(
      oiId: json['OI_id'],
      quantity: json['quantity'],
      cyId: json['cy_id'],
      cylinderType: json['CylinderType'] ?? '',
    );
  }
}
