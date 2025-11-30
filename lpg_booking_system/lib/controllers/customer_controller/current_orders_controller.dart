import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/my_orders_response.dart';

class CustomerOrdersController {
  Future<List<CustomerOrders>> fetchCurrentOrders(String buyerId) async {
    final url = Uri.parse("$baseurl/Orders/GetCurrentOrders?buyerId=$buyerId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CustomerOrders.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load current orders");
    }
  }
}
