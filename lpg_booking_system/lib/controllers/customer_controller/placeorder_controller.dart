import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/placeorder_request.dart';
import 'package:lpg_booking_system/models/customers_models/placeorder_response.dart';

class OrderController {
  // final String baseUrl = "http://10.0.2.2:5000/api/orders"; // local API

  Future<OrderResponse> placeOrder(OrderRequest request) async {
    final url = Uri.parse("$baseurl/Orders/PlaceOrder");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return OrderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to place order: ${response.body}");
    }
  }
}
