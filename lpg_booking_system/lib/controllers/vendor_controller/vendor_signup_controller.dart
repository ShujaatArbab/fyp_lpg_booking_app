import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/vendor_signup_request.dart';
import 'package:lpg_booking_system/models/vendors_models/vendor_signup_response.dart';

class VendorSignupController {
  final url = Uri.parse(
    '$baseurl/Auth/signupVendor',
  ); // replace with your backend URL

  /// Vendor signup API call
  Future<VendorSignupResponse?> signupVendor(
    VendorSignupRequest request,
  ) async {
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // Parse successful response
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return VendorSignupResponse.fromJson(jsonResponse);
      } else {
        // Handle non-200 responses
        return VendorSignupResponse(
          message: "Failed: ${response.statusCode}",
          data: null,
        );
      }
    } catch (e) {
      // Handle exceptions (network issues, etc.)
      return VendorSignupResponse(
        message: "Error: ${e.toString()}",
        data: null,
      );
    }
  }
}
