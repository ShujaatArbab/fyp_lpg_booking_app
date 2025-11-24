// controllers/rating_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/rating_request.dart';

class RatingController {
  Future<String> submitRating(RatingRequest request) async {
    final url = Uri.parse("$baseurl/Orders/RateOrder");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return "success";
    } else if (response.statusCode == 400) {
      return "already_rated";
    } else {
      return "error";
    }
  }
}
