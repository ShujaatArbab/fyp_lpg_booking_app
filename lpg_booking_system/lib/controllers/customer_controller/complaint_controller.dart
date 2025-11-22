import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/complaint_reponse.dart';
import 'package:lpg_booking_system/models/customers_models/complaint_request.dart';

class ComplaintService {
  Future<ComplaintResponse> submitComplaint(ComplaintRequest request) async {
    final url = Uri.parse("$baseurl/Complaints/WriteComplaint");

    final response = await http.post(
      url,
      body: jsonEncode(request.toJson()),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ComplaintResponse.fromJson(data);
    } else {
      throw Exception("Failed to send complaint: ${response.body}");
    }
  }
}
