import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/delivery_person_models/set_delivered_response.dart';

Future<SetDeliveredResponse> setOrderDelivered(int orderId) async {
  final url = Uri.parse(
    "$baseurl/DeliveryPersons/SetOrderDelivered?orderId=$orderId",
  );

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(orderId), // only the orderId
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SetDeliveredResponse.fromJson(data);
    } else {
      // For any non-200 response, return generic error
      return SetDeliveredResponse(message: "Failed to set order as delivered");
    }
  } catch (e) {
    return SetDeliveredResponse(message: "Exception: $e");
  }
}
