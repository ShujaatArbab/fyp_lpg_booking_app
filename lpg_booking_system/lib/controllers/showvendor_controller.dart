import 'dart:convert';
import 'package:http/http.dart' as http;
<<<<<<< HEAD
import 'package:lpg_booking_system/global/global_IP.dart';
=======
>>>>>>> 6b0be65b97d3007188a1a14956f167ac4559507d
import 'package:lpg_booking_system/models/showvendor_response.dart';

class VendorController {
  Future<List<VendorResponse>> fetchVendorsByCity(
    String city,
    String role,
  ) async {
<<<<<<< HEAD
    // const String baseUrl = 'http://192.168.18.62/lpgbookingapp_api/api/Vendors';
    final url = Uri.parse('$baseurl/Vendors/getvendorsbycity');
=======
    const String baseUrl = 'http://192.168.100.4/lpgbookingapp_api/api/Vendors';
    final url = Uri.parse('$baseUrl/getvendorsbycity');
>>>>>>> 6b0be65b97d3007188a1a14956f167ac4559507d

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
