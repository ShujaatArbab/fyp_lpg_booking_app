import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/models/showvendor_response.dart';

class VendorController {
  Future<List<VendorResponse>> fetchVendorsByCity(
    String city,
    String role,
  ) async {
    const String baseUrl = 'http://192.168.100.4/lpgbookingapp_api/api/Vendors';
    final url = Uri.parse('$baseUrl/getvendorsbycity');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'city': city, 'Role': role}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => VendorResponse.fromJson(json)).toList();
      } else {
        // Handle non-200 response
        throw Exception('Failed to load vendors: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error (network error, JSON error, etc.)
      print('Error fetching vendors: $e');
      rethrow; // optional: rethrow if you want to handle it at a higher level
    }
  }
}
