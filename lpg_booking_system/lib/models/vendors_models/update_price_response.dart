class UpdatePriceResponse {
  final String message;
  final int stockId;
  final int price;

  UpdatePriceResponse({
    required this.message,
    required this.stockId,
    required this.price,
  });

  // From JSON factory
  factory UpdatePriceResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePriceResponse(
      message: json['message'] ?? '',
      stockId: json['stock_id'] ?? 0,
      price: json['price'] ?? 0,
    );
  }

  // Optional: to JSON if needed
  Map<String, dynamic> toJson() {
    return {'message': message, 'stock_id': stockId, 'price': price};
  }
}
