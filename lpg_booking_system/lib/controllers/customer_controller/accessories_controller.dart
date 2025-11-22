import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/accessories_request.dart';
import 'package:lpg_booking_system/models/customers_models/accessories_response.dart';

class AccessoriesController {
  Future<AccessoriesResponse?> placeAccessoriesOrder(
    AccessoriesRequest request,
  ) async {
    final url = Uri.parse('$baseurl/Accessories/addAccessories');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AccessoriesResponse.fromJson(jsonData);
      } else {
        print('Accessories API failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
