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
      oiId: json['OI_id'],
      quantity: json['quantity'],
      cyId: json['cy_id'],
      cylinderType: json['CylinderType'],
    );
  }
}

class CustomerOrder {
  final int orderId;
  final String buyerName;
  final String sellerName;
  final String status;
  final String city;
  final String? oDate;
  final String? deliveryDate;
  final int? price;
  final List<CustomerOrderItem> items;

  CustomerOrder({
    required this.orderId,
    required this.buyerName,
    required this.sellerName,
    required this.status,
    required this.city,
    this.oDate,
    this.deliveryDate,
    this.price,
    required this.items,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    var list = (json['Items'] as List?) ?? [];
    List<CustomerOrderItem> items =
        list.map((i) => CustomerOrderItem.fromJson(i)).toList();

    return CustomerOrder(
      orderId: json['Order_id'],
      buyerName: json['BuyerName'],
      sellerName: json['SellerName'],
      status: json['status'],
      city: json['City'],
      oDate: json['o_date'],
      deliveryDate: json['delivery_date'],
      price: json['price'],
      items: items,
    );
  }
}
