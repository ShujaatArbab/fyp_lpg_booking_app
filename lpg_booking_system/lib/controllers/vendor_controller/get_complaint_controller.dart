import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/get_complaint_response.dart';

class VendorComplaintService {
  Future<List<GetComplaintResponse>> getComplaintsByVendor(
    String vendorId,
  ) async {
    final url = Uri.parse(
      "$baseurl/Complaints/GetComplaints?vendorId=$vendorId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => GetComplaintResponse.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load complaints");
    }
  }
}
