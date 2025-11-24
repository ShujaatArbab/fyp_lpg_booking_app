// models/rating_response.dart
class RatingResponse {
  final String message;
  final int orderId;
  final double rating;

  RatingResponse({
    required this.message,
    required this.orderId,
    required this.rating,
  });

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      message: json['message'],
      orderId: json['orderId'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
