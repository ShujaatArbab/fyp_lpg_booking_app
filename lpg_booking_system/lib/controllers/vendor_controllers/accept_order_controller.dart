import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';

class AcceptOrderController {
  /// Accept an order
  static Future<Map<String, dynamic>> acceptOrder({
    required int orderId,
    required String vendorId,
  }) async {
    final url = Uri.parse("$baseurl/Orders/AcceptOrder");

    final body = json.encode({"OrderId": orderId, "SellerId": vendorId});

    final headers = {"Content-Type": "application/json"};

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Failed to accept order: ${response.body}");
    }
  }
}
