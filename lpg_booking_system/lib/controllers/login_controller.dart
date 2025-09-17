import 'dart:convert';
import 'package:http/http.dart' as http;
<<<<<<< HEAD
import 'package:lpg_booking_system/global/global_IP.dart';
=======
>>>>>>> 6b0be65b97d3007188a1a14956f167ac4559507d
import 'package:lpg_booking_system/models/login_request.dart';
import 'package:lpg_booking_system/models/login_response.dart';

class LoginController {
  Future<LoginResponse?> login(LoginRequest request) async {
<<<<<<< HEAD
    // const String baseUrl = 'http://192.168.18.62/lpgbookingapp_api/api/Auth';
    final url = Uri.parse('$baseurl/Auth/login');
=======
    const String baseUrl = 'http://192.168.100.4/lpgbookingapp_api/api/Auth';
    final url = Uri.parse('$baseUrl/login');
>>>>>>> 6b0be65b97d3007188a1a14956f167ac4559507d
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonData);
      } else {
        print('Login Failed:${response.body}');
        return null;
      }
    } catch (e) {
      print('Error {$e}');
      return null;
    }
  }
}
