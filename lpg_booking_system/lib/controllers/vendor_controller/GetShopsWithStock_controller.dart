import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/GetShopsWithStock.dart';

class VendorService {
  final String baseUrl;

  VendorService({required this.baseUrl});

  Future<List<GetShopsWithShop>> getShopsWithStock(String userId) async {
    final url = Uri.parse('$baseurl/Vendors/GetShopsWithStock?userId=$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((shop) => GetShopsWithShop.fromJson(shop)).toList();
    } else {
      throw Exception('Failed to fetch shops with stock');
    }
  }
}
