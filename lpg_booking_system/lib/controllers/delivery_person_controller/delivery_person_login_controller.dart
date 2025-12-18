import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/delivery_person_models/deliver_person_login_request.dart';
import 'package:lpg_booking_system/models/delivery_person_models/deliver_person_login_response.dart'; // your base URL

class DeliveryLoginController {
  Future<DeliveryLoginResponse?> Deliverylogin(
    DeliveryLoginRequest request,
  ) async {
    final url = Uri.parse("$baseurl/Auth/DeliveryLogin");

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return DeliveryLoginResponse.fromJson(jsonDecode(response.body));
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
