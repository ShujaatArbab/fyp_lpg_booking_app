import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/update_price_request.dart';
import 'package:lpg_booking_system/models/vendors_models/update_price_response.dart';

class Price {
  Future<UpdatePriceResponse> updateprice(UpdatePriceRequest request) async {
    final url = Uri.parse('$baseurl/Vendors/UpdatePrice');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UpdatePriceResponse.fromJson(data);
    } else {
      throw Exception('Failed to update price: ${response.body}');
    }
  }
}
