import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/controllers/customer_controller/signupresult_controller.dart';

import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/signup_request.dart';
import 'package:lpg_booking_system/models/customers_models/signup_response.dart';

class SignupController {
  Future<SignupResult?> Signup(SignupRequest request) async {
    // const String baseUrl = 'http://192.168.18.62/lpgbookingapp_api/api/Auth';
    final url = Uri.parse('$baseurl/Auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final signupData = SignupResponse.fromJson(jsonData['data']);
        return SignupResult(data: signupData); // ✅ success
      } else {
        final body = response.body.trim();

        final errorMessage =
            body.startsWith('{')
                ? jsonDecode(body)['message'] ?? 'Signup failed'
                : body;
        return SignupResult(error: errorMessage);
      }
    } catch (e) {
      print('signup Exception: $e');
      return SignupResult(
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}
