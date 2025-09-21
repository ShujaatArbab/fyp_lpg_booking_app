import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/suppliers_models/supplier_signup_request.dart';
import 'package:lpg_booking_system/models/suppliers_models/supplier_signup_response.dart';

class SupplierSignupController {
  // ⚠️ API URL (use localhost for emulator)

  Future<SupplierSignupResponse?> signupSupplier(
    SupplierSignupRequest request,
  ) async {
    final url = Uri.parse("$baseurl/Auth/signupSupplier");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return SupplierSignupResponse.fromJson(json);
      } else {
        print("❌ Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}
