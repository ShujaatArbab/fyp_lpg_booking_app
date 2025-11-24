import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/cancel_order_request.dart';
import 'package:lpg_booking_system/models/customers_models/cancel_order_response.dart';

class CancelOrderController {
  Future<CancelOrderResponse?> cancelOrder(CancelOrderRequest request) async {
    final url = Uri.parse("$baseurl/Orders/CancelOrder");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return CancelOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      print("Cancel failed: ${response.body}");
      return null;
    }
  }
}
