class OrderItemRequest {
  final int stockId;
  final int quantity;

  OrderItemRequest({required this.stockId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {"stock_id": stockId, "quantity": quantity};
  }
}

class OrderRequest {
  final String buyerId;
  final String sellerId;
  final String city;
  final List<OrderItemRequest> items;

  OrderRequest({
    required this.buyerId,
    required this.sellerId,
    required this.city,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "Buyer_id": buyerId,
      "Seller_id": sellerId,
      "City": city,
      "OrderItems": items.map((e) => e.toJson()).toList(), // ✅ FIXED
    };
  }
}
