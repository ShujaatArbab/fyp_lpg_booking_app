// models/rating_request.dart
class RatingRequest {
  final int orderId;
  final double rating;

  RatingRequest({required this.orderId, required this.rating});

  Map<String, dynamic> toJson() => {'orderId': orderId, 'rating': rating};
}
