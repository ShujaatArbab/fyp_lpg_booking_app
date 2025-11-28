// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/vendor_dashboard_response.dart';

class ApiService {
  Future<VendorDashboard?> getVendorDashboard(String vendorId) async {
    final url = Uri.parse(
      '$baseurl/Vendors/GetVendorDashboard?vendorId=$vendorId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return VendorDashboard.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
