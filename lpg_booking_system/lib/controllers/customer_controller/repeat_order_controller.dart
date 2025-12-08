import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/repeat_order_response.dart';

class RepeatOrderController {
  Future<RepeatOrderResponse?> fetchOrderDetails(int orderId) async {
    final response = await http.get(
      Uri.parse("$baseurl/Orders/RepeatOrder?orderId=$orderId"),
    );

    if (response.statusCode == 200) {
      return RepeatOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // Send only the orderId as a number
  Future<bool> placeRepeatedOrder(int orderId) async {
    final response = await http.post(
      Uri.parse("$baseurl/Orders/RepeatOrderPlace"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(orderId), // <-- send integer, not full JSON
    );

    return response.statusCode == 200;
  }
}
