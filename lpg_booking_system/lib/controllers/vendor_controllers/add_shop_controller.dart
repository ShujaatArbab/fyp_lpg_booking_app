import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/add_shop_response.dart';
import 'package:lpg_booking_system/models/vendors_models/addshop_request.dart';

class AddShopController {
  // adjust for your backend

  Future<AddShopResponse?> addShop(AddShopRequest request) async {
    final url = Uri.parse("$baseurl/Shops/AddShop");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return AddShopResponse.fromJson(jsonDecode(response.body));
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
