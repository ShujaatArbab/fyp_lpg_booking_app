class OrderItemRequest {
  final int stockId;
  final int quantity;

  OrderItemRequest({required this.stockId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {"stock_id": stockId, "quantity": quantity};
  }
}

class VendorOrderRequest {
  final String buyerId; // Vendor ID
  final String sellerId; // Supplier ID
  final List<OrderItemRequest> orderItems;
  final int totalPrice;

  VendorOrderRequest({
    required this.buyerId,
    required this.sellerId,
    required this.orderItems,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "Buyer_id": buyerId,
      "Seller_id": sellerId,
      "OrderItems": orderItems.map((e) => e.toJson()).toList(),
      "price": totalPrice,
    };
  }
}
