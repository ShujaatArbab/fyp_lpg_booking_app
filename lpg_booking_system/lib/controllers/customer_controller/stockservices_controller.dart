import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';

class StockService {
  static Future<Map<String, int>> getStockMap(String vendorId) async {
    final url = Uri.parse("$baseurl/Stocks/GetStockByVendor/$vendorId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      Map<String, int> stockMap = {};
      for (var item in data) {
        String size = item['CylinderSize'];
        int stockId = item['stock_id'];
        stockMap[size] = stockId;
      }

      return stockMap;
    } else {
      throw Exception("Failed to load stock for vendor $vendorId");
    }
  }
}
