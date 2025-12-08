import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/scheduled_request.dart';
import 'package:lpg_booking_system/models/customers_models/scheduled_response.dart';

class ScheduleController {
  Future<ScheduleOrderResponse?> scheduleOrder(
    ScheduleOrderRequest request,
  ) async {
    final url = Uri.parse("$baseurl/Schedules/ScheduleOrder");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()), // Correct JSON format
    );

    if (response.statusCode == 200) {
      return ScheduleOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed: ${response.statusCode} → ${response.body}");
    }
  }
}
