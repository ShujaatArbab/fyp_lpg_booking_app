// vendor_scheduled_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/see_schedule_order.dart';

class VendorScheduledController {
  final String baseUrl;

  VendorScheduledController({required this.baseUrl});

  Future<List<VendorScheduledOrder>> fetchScheduledOrders(
    String vendorId,
  ) async {
    final url = Uri.parse(
      "$baseurl/Schedules/GetVendorScheduledOrders?vendorId=$vendorId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => VendorScheduledOrder.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      return []; // No scheduled orders
    } else {
      throw Exception(
        "Failed to fetch scheduled orders: ${response.statusCode}",
      );
    }
  }
}
