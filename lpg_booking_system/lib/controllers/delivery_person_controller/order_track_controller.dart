import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/delivery_person_models/track_order_request.dart';
import 'package:lpg_booking_system/models/delivery_person_models/track_order_response.dart';

class OrderTrackingService {
  // Save location
  static Future<bool> saveLocation(OrderTrackingRequest model) async {
    final response = await http.post(
      Uri.parse("$baseurl/OrderTrackings/SaveLocation"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    return response.statusCode == 200;
  }

  // Get latest location
  static Future<OrderTrackingResponse?> getLatestLocation(int orderId) async {
    final response = await http.get(
      Uri.parse("$baseurl/OrderTrackings/GetLatestLocation?orderId=$orderId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return OrderTrackingResponse.fromJson(data);
    } else {
      return null;
    }
  }
}
