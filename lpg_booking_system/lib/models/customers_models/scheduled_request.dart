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
    "CustId": custId, // Must match exactly like "C-3506"
    "OrderId": orderId,
    // Format date as "YYYY-MM-DD" to match API
    "ScDate":
        "${scDate.year.toString().padLeft(4, '0')}-${scDate.month.toString().padLeft(2, '0')}-${scDate.day.toString().padLeft(2, '0')}",
  };
}
