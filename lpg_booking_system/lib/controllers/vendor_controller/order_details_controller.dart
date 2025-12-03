import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/order_details_response.dart';

class VendorOrderDetailsController {
  /// Fetch order details by orderId
  Future<OrderDetailsResponse?> fetchOrderDetails(int orderId) async {
    final url = Uri.parse("$baseurl/Orders/GetOrderDetails?orderId=$orderId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OrderDetailsResponse.fromJson(data);
      } else {
        print("Failed to load order details: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching order details: $e");
      return null;
    }
  }
}
