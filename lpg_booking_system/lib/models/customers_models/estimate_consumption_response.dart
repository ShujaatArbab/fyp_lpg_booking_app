class ConsumptionResponse {
  final String id;
  final String month;
  final List<String> messages; // change from String to List<String>
  final double total;

  ConsumptionResponse({
    required this.id,
    required this.month,
    required this.messages,
    required this.total,
  });

  factory ConsumptionResponse.fromJson(Map<String, dynamic> json) {
    return ConsumptionResponse(
      id: json["CustomerId"],
      month: json["Month"],
      messages: List<String>.from(
        json["Messages"] ?? [],
      ), // convert List<dynamic> to List<String>
      total: (json["TotalKg"] as num).toDouble(),
    );
  }
}
