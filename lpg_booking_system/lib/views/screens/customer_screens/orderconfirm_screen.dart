import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/placeorder_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/stockservices_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/accessories_controller.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/customers_models/accessories_request.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/placeorder_request.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/finalorderconfirm_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';
import 'package:lpg_booking_system/widgets/customer_navbar.dart';

class OrderconfirmationScreen extends StatefulWidget {
  final List<TankItem> selecteditem;
  final String vendorName;
  final String vendorAddress;
  final String vendorPhone;
  final String vendorcity;
  final LoginResponse customer;
  final String vendorId;

  const OrderconfirmationScreen({
    super.key,
    required this.selecteditem,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorPhone,
    required this.vendorId,
    required this.vendorcity,
    required this.customer,
  });

  @override
  State<OrderconfirmationScreen> createState() =>
      _OrderconfirmationScreenState();
}

class _OrderconfirmationScreenState extends State<OrderconfirmationScreen> {
  Map<String, int> stockMap = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadStock(widget.vendorId);
  }

  /// Load stock map from API
  Future<void> loadStock(String vendorId) async {
    try {
      final map = await StockService.getStockMap(vendorId);
      setState(() {
        stockMap = map;
      });
    } catch (e) {
      print("Error loading stock: $e");
    }
  }

  /// Place accessories for a single cylinder
  Future<void> placeAccessories(TankItem item) async {
    if (item.accessories == null || item.accessories!.isEmpty) return;

    final controller = AccessoriesController();

    for (var acc in item.accessories!) {
      // acc format: "Cooking / Stove x2"
      var parts = acc.split(' x');
      var purpose = parts[0].trim();
      var quantity = int.tryParse(parts[1].trim()) ?? 1;

      final request = AccessoriesRequest(
        userId: widget.customer.userid,
        cylinderId: getCylinderId(item.size),
        usagePurpose: purpose,
        quantity:
            quantity, // API might still expect string, backend converts to int
      );

      try {
        await controller.placeAccessoriesOrder(request);
      } catch (e) {
        print("Accessories API failed for $purpose: $e");
      }
    }
  }

  /// Map tank size to cylinder ID for Accessories API
  int getCylinderId(String size) {
    switch (size) {
      case '11kg':
        return 1;
      case '15kg':
        return 2;
      case '45kg':
        return 3;
      default:
        return 0;
    }
  }

  /// Place order API call
  Future<void> _placeOrder() async {
    if (widget.selecteditem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one cylinder")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final sellerId = widget.vendorId;

    try {
      // First, place accessories API for each cylinder
      for (var item in widget.selecteditem) {
        await placeAccessories(item);
      }

      // Build order request
      final request = OrderRequest(
        buyerId: widget.customer.userid,
        sellerId: sellerId,
        city: widget.vendorcity,
        items:
            widget.selecteditem.map((c) {
              return OrderItemRequest(
                stockId: stockMap[c.size]!,
                quantity: c.quantity,
              );
            }).toList(),
      );

      // Place order API call
      final response = await OrderController().placeOrder(request);
      final orderId = response.orderId;

      // Navigate to final confirmation screen
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierDismissible: false,
        builder:
            (_) => FinalorderconfirmScreen(
              orderid: orderId,
              selecteditem: widget.selecteditem,
              vendorName: widget.vendorName,
              vendorAddress: widget.vendorAddress,
              vendorPhone: widget.vendorPhone,
              vendorCity: widget.vendorcity,
              customer: widget.customer,
              vendorId: widget.vendorId,
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to place order: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void deleteCylinder(int index) {
    setState(() {
      widget.selecteditem.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerNavbar(
        currentindex: 0,
        ontap: (int index) {
          setState(() {});
        },
      ),
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Vendor & Customer Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vendor Address: ${widget.vendorAddress}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'My Address: ${widget.customer.city}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Products:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // List of selected cylinders with accessories
          Expanded(
            child:
                widget.selecteditem.isEmpty
                    ? const Center(child: Text("No products added"))
                    : ListView.builder(
                      itemCount: widget.selecteditem.length,
                      itemBuilder: (context, index) {
                        final cylinder = widget.selecteditem[index];
                        return CustomCylinderCard(
                          size: cylinder.size,
                          price: cylinder.price,
                          quantity: cylinder.quantity,
                          onDelete: () => deleteCylinder(index),
                          extraWidget:
                              cylinder.accessories != null
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        cylinder.accessories!
                                            .map(
                                              (acc) => Text(
                                                acc,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  )
                                  : null,
                        );
                      },
                    ),
          ),

          // Vendor location & phone
          Container(
            padding: const EdgeInsets.only(left: 50, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location: ${widget.vendorcity}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Phone: ${widget.vendorPhone}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Place Order Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _placeOrder,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Place Order',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
