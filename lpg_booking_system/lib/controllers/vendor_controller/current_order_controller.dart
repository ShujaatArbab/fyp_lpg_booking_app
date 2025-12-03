import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/currentorders_reponse.dart';

class VendorCurrentOrdersController {
  /// Fetch Current Orders (Pending or Dispatched)
  Future<List<VendorCurrentOrder>> getCurrentOrders(String vendorId) async {
    final url = Uri.parse(
      "$baseurl/Orders/GetVendorCurrentOrders?vendorId=$vendorId",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => VendorCurrentOrder.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load vendor current orders");
    }
  }
}
