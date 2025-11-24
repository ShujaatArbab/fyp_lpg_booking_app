import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/suppliers_models/getsupplier_order_response.dart';

class OrderService {
  /// Fetch supplier orders from API
  static Future<List<SupplierOrder>> getSupplierOrders(
    String supplierId,
  ) async {
    final url = Uri.parse("$baseurl/Suppliers/GetSupplierOrders/$supplierId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode JSON response
        final List<dynamic> data = json.decode(response.body);

        // Map JSON to List<SupplierOrder>
        List<SupplierOrder> orders =
            data.map((json) => SupplierOrder.fromJson(json)).toList();
        return orders;
      } else {
        throw Exception(
          "Failed to load supplier orders: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching supplier orders: $e");
    }
  }
}
