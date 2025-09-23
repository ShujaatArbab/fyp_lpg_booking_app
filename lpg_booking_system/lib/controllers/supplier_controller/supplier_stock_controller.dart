import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/suppliers_models/supplier_stock_response.dart';

class SupplierStockService {
  static Future<List<SupplierStock>> getSupplierStock(String supplierId) async {
    final url = Uri.parse("$baseurl/Stocks/GetStockBySupplier/$supplierId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => SupplierStock.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load stock for supplier $supplierId");
    }
  }
}
