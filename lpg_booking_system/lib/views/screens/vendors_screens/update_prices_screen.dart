import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/GetShopsWithStock_controller.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/update_price_controller.dart';
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/GetShopsWithStock.dart';
import 'package:lpg_booking_system/models/vendors_models/update_price_request.dart';

class UpdatePricesScreen extends StatefulWidget {
  final String vendorUserId; // pass the logged-in vendor userId

  const UpdatePricesScreen({super.key, required this.vendorUserId});

  @override
  State<UpdatePricesScreen> createState() => _UpdatePricesScreenState();
}

class _UpdatePricesScreenState extends State<UpdatePricesScreen> {
  late VendorService vendorService;
  List<GetShopsWithShop> shops = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    vendorService = VendorService(baseUrl: baseurl);
    fetchShops();
  }

  Future<void> fetchShops() async {
    setState(() => isLoading = true);
    try {
      final result = await vendorService.getShopsWithStock(widget.vendorUserId);
      setState(() {
        shops = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching shops: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updatePrice(int shopId, int cylinderId, int price) async {
    try {
      final request = UpdatePriceRequest(
        userId: widget.vendorUserId,
        shopId: shopId,
        cylinderId: cylinderId,
        price: price,
      );

      final priceService = Price();
      final response = await priceService.updateprice(request);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      await fetchShops(); // refresh UI after update
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update price: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Prices',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top heading
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'Shops / Plants',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: shops.length,
                        itemBuilder: (context, index) {
                          final shop = shops[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Shop name in card
                                  Text(
                                    shop.shopName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const Divider(color: Colors.orange),
                                  const SizedBox(height: 8),
                                  // Stocks
                                  ...shop.stocks.map((stock) {
                                    final controller = TextEditingController(
                                      text:
                                          stock.price != '0' ? stock.price : '',
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${stock.cylinderName} (${stock.quantityAvailable} available)',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  stock.price == '0'
                                                      ? 'Current Price: 0'
                                                      : 'Current Price: ${stock.price}',
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: controller,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText: 'Enter Price',
                                                labelStyle: TextStyle(
                                                  fontSize: 15,
                                                ),

                                                border:
                                                    const OutlineInputBorder(),
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                              ),
                                              onPressed: () {
                                                final int? newPrice =
                                                    int.tryParse(
                                                      controller.text,
                                                    );
                                                if (newPrice != null) {
                                                  updatePrice(
                                                    int.parse(shop.shopId),
                                                    int.parse(stock.cyId),
                                                    newPrice,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Enter a valid price',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Update',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
