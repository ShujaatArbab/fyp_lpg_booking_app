import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';

import 'package:lpg_booking_system/models/vendors_models/place_order_request.dart';
import 'package:lpg_booking_system/models/vendors_models/place_order_response.dart';

class VendorOrder {
  Future<VendorOrderResponse> vendorplacesorders(
    VendorOrderRequest request,
  ) async {
    final url = Uri.parse("$baseurl/Orders/VendorPlaceOrder");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return VendorOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to place order: ${response.body}");
    }
  }
}
