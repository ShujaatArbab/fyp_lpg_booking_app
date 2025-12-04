class AssignDeliveryPersonResponse {
  final String message;

  AssignDeliveryPersonResponse({required this.message});

  factory AssignDeliveryPersonResponse.fromJson(Map<String, dynamic> json) {
    return AssignDeliveryPersonResponse(message: json["message"]);
  }
}
