class CancelOrderResponse {
  final String message;
  final int orderId;

  CancelOrderResponse({required this.message, required this.orderId});

  factory CancelOrderResponse.fromJson(Map<String, dynamic> json) {
    return CancelOrderResponse(
      message: json["message"],
      orderId: json["orderId"],
    );
  }
}
