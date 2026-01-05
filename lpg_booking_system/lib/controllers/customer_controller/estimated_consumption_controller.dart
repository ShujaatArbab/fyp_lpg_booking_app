import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/estimate_consumption_response.dart';

class Consumption {
  Future<List<ConsumptionResponse>> fetchlpgconsumption(String userid) async {
    final url = Uri.parse(
      "$baseurl/Accessories/GetCustomerLpgUsage?customerId=$userid",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Wrap single object in a list
      return [ConsumptionResponse.fromJson(jsonData)];
    } else {
      throw Exception("Failed to load LPG consumption");
    }
  }
}
