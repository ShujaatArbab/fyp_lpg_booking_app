import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';

class GetSupplierStock {
  /// Fetch supplier stock from API
  static Future<Map<String, int>> GetsSuppliersStocks(String supplierId) async {
    final url = Uri.parse("$baseurl/Stocks/GetStockBySupplier?id=$supplierId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<String, int> stockMap = {};
      for (var item in data) {
        final size = item['CylinderSize'] as String;
        final stockId = item['stock_id'] as int;
        stockMap[size] = stockId;
      }

      return stockMap;
    } else if (response.statusCode == 404) {
      throw Exception("No stock found for this supplier");
    } else {
      throw Exception("Failed to fetch supplier stock: ${response.statusCode}");
    }
  }
}
