import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/assign_deliveryperson_request.dart';
import 'package:lpg_booking_system/models/vendors_models/assign_deliveryperson_response.dart';

class AssignDeliveryPersonController {
  Future<AssignDeliveryPersonResponse?> assignDeliveryPerson(
    AssignDeliveryPersonRequest request,
  ) async {
    final url = Uri.parse("$baseurl/DeliveryPersons/AssignDeliveryPerson");
    print("URL: $url");
    print("Request Body: ${jsonEncode(request.toJson())}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Use correct capitalization from API response
        return AssignDeliveryPersonResponse(
          message: data["Message"] ?? "Success",
        );
      } else {
        print("Failed: ${response.body}");
        return AssignDeliveryPersonResponse(
          message: "Failed: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error: $e");
      return AssignDeliveryPersonResponse(message: "Error: $e");
    }
  }
}
