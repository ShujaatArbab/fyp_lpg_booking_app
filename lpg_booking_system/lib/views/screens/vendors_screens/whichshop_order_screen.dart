import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/GetShopsWithStock_controller.dart';
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/GetShopsWithStock.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/ven_place_order_screen.dart';
// Import your next screen

class WhichshopOrderScreen extends StatefulWidget {
  final String supplierId;
  final String supplierName;
  final String supplierPhone;
  final String supplierAddress;
  final String supplierCity;
  final LoginResponse vendor;
  final int smallQty;
  final int mediumQty;
  final int largeQty;
  final int smallPrice;
  final int mediumPrice;
  final int largePrice;

  const WhichshopOrderScreen({
    super.key,
    required this.supplierId,
    required this.supplierName,
    required this.supplierPhone,
    required this.supplierAddress,
    required this.supplierCity,
    required this.vendor,
    required this.smallQty,
    required this.mediumQty,
    required this.largeQty,
    required this.smallPrice,
    required this.mediumPrice,
    required this.largePrice,
  });

  @override
  State<WhichshopOrderScreen> createState() => _WhichshopOrderScreenState();
}

class _WhichshopOrderScreenState extends State<WhichshopOrderScreen> {
  late Future<List<GetShopsWithShop>> shopsFuture;

  @override
  void initState() {
    super.initState();
    shopsFuture = VendorService(
      baseUrl: baseurl,
    ).getShopsWithStock(widget.vendor.userid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Shop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),

      body: FutureBuilder<List<GetShopsWithShop>>(
        future: shopsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No shops found."));
          }

          final shops = snapshot.data!;

          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];

              return Card(
                margin: EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SHOP NAME + CITY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shop.shopName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            shop.shopCity,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),

                      SizedBox(height: 6),

                      // SHOP ID
                      Text(
                        "Shop ID: ${shop.shopId}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 12),

                      // STOCK LIST
                      Text(
                        "Stocks Available:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Column(
                        children:
                            shop.stocks.map((stock) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(stock.cylinderName),
                                    Text("Qty: ${stock.quantityAvailable}"),
                                    Text("Price: ${stock.price}"),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),

                      SizedBox(height: 15),

                      // BUTTON
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => VendorPlaceorderScreen(
                                      shopId: shop.shopId, // IMPORTANT
                                      supplierId: widget.supplierId,
                                      supplierName: widget.supplierName,
                                      supplierPhone: widget.supplierPhone,
                                      supplierAddress: widget.supplierAddress,
                                      supplierCity: widget.supplierCity,
                                      vendor: widget.vendor,
                                      smallQty: widget.smallQty,
                                      mediumQty: widget.mediumQty,
                                      largeQty: widget.largeQty,
                                      smallPrice: widget.smallPrice,
                                      mediumPrice: widget.mediumPrice,
                                      largePrice: widget.largePrice,
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            "Add Stock",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ---- Helper Functions ----

  int _getQty(GetShopsWithShop shop, String cyId) {
    final s = shop.stocks.firstWhere(
      (x) => x.cyId == cyId,
      orElse:
          () => GetShopsWithStock(
            stockId: "0",
            cyId: cyId,
            cylinderName: "",
            quantityAvailable: "0",
            price: "0",
          ),
    );
    return int.tryParse(s.quantityAvailable) ?? 0;
  }

  int _getPrice(GetShopsWithShop shop, String cyId) {
    final s = shop.stocks.firstWhere(
      (x) => x.cyId == cyId,
      orElse:
          () => GetShopsWithStock(
            stockId: "0",
            cyId: cyId,
            cylinderName: "",
            quantityAvailable: "0",
            price: "0",
          ),
    );
    return int.tryParse(s.price) ?? 0;
  }
}
