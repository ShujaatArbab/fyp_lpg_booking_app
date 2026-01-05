class SetDeliveredResponse {
  final String message;
  final int? orderId; // nullable in case of failure

  SetDeliveredResponse({required this.message, this.orderId});

  factory SetDeliveredResponse.fromJson(Map<String, dynamic> json) {
    return SetDeliveredResponse(
      message: json['message'] ?? '',
      orderId: json['OrderId'], // may be null if error
    );
  }
}
