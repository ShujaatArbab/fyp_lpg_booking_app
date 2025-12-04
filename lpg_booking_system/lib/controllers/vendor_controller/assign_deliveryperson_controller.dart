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

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return AssignDeliveryPersonResponse.fromJson(jsonDecode(response.body));
    } else {
      print("Failed: ${response.body}");
      return null;
    }
  }
}
