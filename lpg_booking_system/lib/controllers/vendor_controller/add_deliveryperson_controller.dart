import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/add_deliveryperson_request.dart';
import 'package:lpg_booking_system/models/vendors_models/add_deliveryperson_response.dart';

class AddDPController {
  // adjust for your backend

  Future<AddDPResponse?> addDeliveryPerson(AddDPRequest request) async {
    final url = Uri.parse("$baseurl/DeliveryPersons/AddDeliveryPerson");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return AddDPResponse.fromJson(jsonDecode(response.body));
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
