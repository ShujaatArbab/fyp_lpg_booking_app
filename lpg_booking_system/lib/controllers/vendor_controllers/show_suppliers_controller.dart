import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/show_supplier_request.dart';
import 'package:lpg_booking_system/models/vendors_models/show_supplier_response.dart';

class SupplierController {
  Future<List<SupplierResponse>> getSuppliersByCity(
    SupplierRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('$baseurl/Suppliers/getSuppliersByCity'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => SupplierResponse.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch suppliers");
    }
  }
}
