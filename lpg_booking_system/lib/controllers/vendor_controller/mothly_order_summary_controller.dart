import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/monthly_order_response.dart';

class VendorReportService {
  Future<VendorMonthlySummaryResponse> getVendorMonthlySummary(
    String vendorId,
  ) async {
    final url = Uri.parse(
      '$baseurl/Vendors/GetVendorMonthlySummary?id=$vendorId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return VendorMonthlySummaryResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load vendor summary');
    }
  }
}
