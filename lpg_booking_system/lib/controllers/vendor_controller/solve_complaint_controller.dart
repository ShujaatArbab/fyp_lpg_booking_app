import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/solve_complaint_request.dart';
import 'package:lpg_booking_system/models/vendors_models/solve_complaint_response.dart';

class ComplaintsApi {
  Future<VendorComplaintResponse> respondToComplaint(
    VendorComplaintRequest request,
  ) async {
    final url = Uri.parse("$baseurl/Complaints/VendorRespondComplaint");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return VendorComplaintResponse.fromJson(jsonData);
    } else {
      throw Exception("Failed to respond to complaint: ${response.statusCode}");
    }
  }
}
