// services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_IP.dart';
import 'package:lpg_booking_system/models/vendororders_response.dart';

class OrderService {
  static Future<List<Order>> getVendorOrders(String vendorId) async {
    final url = Uri.parse("$baseurl/Vendors/GetVendorOrders/$vendorId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load orders");
    }
  }
}
