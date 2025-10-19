class NotificationResponse {
  final int id;
  final String customerId;
  final int cylinderId;
  final String message;
  final DateTime createdOn;
  final bool isRead;

  NotificationResponse({
    required this.id,
    required this.customerId,
    required this.cylinderId,
    required this.message,
    required this.createdOn,
    required this.isRead,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['Id'] ?? 0,
      customerId: json['CustomerId'] ?? '',
      cylinderId: json['CylinderId'] ?? 0,
      message: json['Message'] ?? '',
      createdOn: DateTime.parse(json['CreatedOn']),
      isRead: json['IsRead'] ?? false,
    );
  }
}
