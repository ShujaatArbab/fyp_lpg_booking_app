import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controllers/place_order_controller.dart';
import 'package:lpg_booking_system/controllers/vendororders_controller.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/place_order_request.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';

class VendorOrderConfirmationScreen extends StatefulWidget {
  final List<TankItem> selectedItems;
  final String supplierName;
  final String supplierPhone;
  final String supplierAddress;
  final String supplierCity;
  final LoginResponse vendor;
  final Map<String, int> stockMap; // Map tank size to stockId

  const VendorOrderConfirmationScreen({
    super.key,
    required this.selectedItems,
    required this.supplierName,
    required this.supplierPhone,
    required this.supplierAddress,
    required this.supplierCity,
    required this.vendor,
    required this.stockMap,
  });

  @override
  State<VendorOrderConfirmationScreen> createState() =>
      _VendorOrderConfirmationScreenState();
}

class _VendorOrderConfirmationScreenState
    extends State<VendorOrderConfirmationScreen> {
  bool _isLoading = false;

  Future<void> _placeOrder() async {
    if (widget.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one cylinder to order"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Build order items
      final orderItems = <OrderItemRequest>[];
      for (var item in widget.selectedItems) {
        final stockId = widget.stockMap[item.size];
        if (stockId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Stock not found for ${item.size}")),
          );
          setState(() => _isLoading = false);
          return;
        }
        orderItems.add(
          OrderItemRequest(stockId: stockId, quantity: item.quantity),
        );
      }

      // Create vendor order request
      final request = VendorOrderRequest(
        buyerId: widget.vendor.userid,
        sellerId: widget.supplierPhone, // or supplierId if available
        orderItems: orderItems,
      );

      // Call API
      final response = await VendorOrder().vendorplacesorders(request);

      // Show success
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      // Optionally navigate to a final screen or clear selected items
      // Navigator.push(...);
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

  void deleteItem(int index) {
    setState(() {
      widget.selectedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Supplier: ${widget.supplierName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Phone: ${widget.supplierPhone}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Address: ${widget.supplierAddress}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "City: ${widget.supplierCity}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Vendor Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vendor: ${widget.vendor.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "UserID: ${widget.vendor.userid}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "City: ${widget.vendor.city}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Products
            const Text(
              "Products:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            widget.selectedItems.isEmpty
                ? const Center(child: Text("No products added"))
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.selectedItems[index];
                    return CustomCylinderCard(
                      size: item.size,
                      price: item.price,
                      quantity: item.quantity,
                      onDelete: () => deleteItem(index),
                      extraWidget: null,
                    );
                  },
                ),
            const SizedBox(height: 20),

            // Place Order Button (like Proceed)
            Center(
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isLoading ? "Placing..." : "Place Order",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
