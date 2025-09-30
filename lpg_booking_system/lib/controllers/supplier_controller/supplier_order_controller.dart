// services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendororders_response.dart';

class GetOrderService {
  /// ✅ Get orders where supplier is the seller (Vendor → Supplier orders)
  static Future<List<Order>> getSupplierOrders(String supplierId) async {
    final url = Uri.parse("$baseurl/Suppliers/GetSupplierOrders/$supplierId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load supplier orders");
    }
  }
}
