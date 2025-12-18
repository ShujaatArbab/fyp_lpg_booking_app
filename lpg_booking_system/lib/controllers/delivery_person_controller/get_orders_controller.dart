import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/delivery_person_models/get_orders_response.dart';

class DeliveryOrderController {
  // Fetch orders for a delivery person by name
  Future<List<DeliveryOrderResponse>> getDeliveryOrders(
    String deliveryPersonName,
  ) async {
    final url = Uri.parse(
      "$baseurl/Orders/GetDeliveryOrders?deliveryPersonName=$deliveryPersonName",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DeliveryOrderResponse.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load delivery orders");
    }
  }
}
