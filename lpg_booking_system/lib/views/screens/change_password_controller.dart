import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/views/screens/change_password_response.dart';
import 'change_password_request.dart';

class Passwordchanging {
  // No need for constructor or baseUrl parameter
  Passwordchanging();

  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  ) async {
    final url = Uri.parse('$baseurl/Auth/ChangePassword'); // use global baseUrl

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ChangePasswordResponse.fromJson(data);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error changing password');
    }
  }
}
