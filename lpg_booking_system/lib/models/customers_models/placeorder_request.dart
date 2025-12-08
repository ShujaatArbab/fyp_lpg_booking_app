class AccessoryRequest {
  final String userId;
  final int cylinderId;
  final String usagePurpose;
  final int quantity;

  AccessoryRequest({
    required this.userId,
    required this.cylinderId,
    required this.usagePurpose,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "UserId": userId,
      "CylinderId": cylinderId,
      "UsagePurpose": usagePurpose,
      "Quantity": quantity,
    };
  }
}

class OrderItemRequest {
  final int stockId;
  final int quantity;
  final List<AccessoryRequest>? accessories;

  OrderItemRequest({
    required this.stockId,
    required this.quantity,
    this.accessories,
  });

  Map<String, dynamic> toJson() {
    return {
      "stock_id": stockId,
      "quantity": quantity,
      "Accessories": accessories?.map((a) => a.toJson()).toList() ?? [],
    };
  }
}

class OrderRequest {
  final String buyerId;
  final String sellerId;
  final String city;
  final int totalPrice;
  final List<OrderItemRequest> orderItems;

  OrderRequest({
    required this.buyerId,
    required this.sellerId,
    required this.city,
    required this.totalPrice,
    required this.orderItems,
  });

  Map<String, dynamic> toJson() {
    return {
      "Buyer_id": buyerId,
      "Seller_id": sellerId,
      "City": city,
      "price": totalPrice,
      "OrderItems": orderItems.map((o) => o.toJson()).toList(),
    };
  }
}
