class ScheduleOrderResponse {
  final String message;
  final int scheduleId;

  ScheduleOrderResponse({required this.message, required this.scheduleId});

  factory ScheduleOrderResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleOrderResponse(
      message: json['Message'],
      scheduleId: json['ScheduleId'],
    );
  }
}
