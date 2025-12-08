class ScheduleOrderRequest {
  final String custId;
  final int orderId;
  final DateTime scDate;

  ScheduleOrderRequest({
    required this.custId,
    required this.orderId,
    required this.scDate,
  });

  Map<String, dynamic> toJson() => {
    "CustId": custId,
    "OrderId": orderId,
    "ScDate": scDate.toIso8601String(),
  };
}
