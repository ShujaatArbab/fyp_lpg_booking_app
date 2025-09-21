import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/deliveryperson_response.dart';

// import your model

class DeliveryPersonService {
  static Future<List<DeliveryPerson>> getDeliveryPersons(
    String vendorId,
  ) async {
    final url = Uri.parse(
      "$baseurl/DeliveryPersons/GetDeliveryPersons/$vendorId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DeliveryPerson.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load delivery persons");
    }
  }
}
