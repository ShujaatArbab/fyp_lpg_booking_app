class AccessoriesResponse {
  final String message;
  final String userId;
  final int cylinderId;
  final String usagePurpose;
  final String quantity;

  AccessoriesResponse({
    required this.message,
    required this.userId,
    required this.cylinderId,
    required this.usagePurpose,
    required this.quantity,
  });

  //! Convert JSON to Dart object
  factory AccessoriesResponse.fromJson(Map<String, dynamic> json) {
    return AccessoriesResponse(
      message: json['Message'],
      userId: json['UserId'],
      cylinderId: json['CylinderId'],
      usagePurpose: json['UsagePurpose'],
      quantity: json['Quantity'],
    );
  }
}
