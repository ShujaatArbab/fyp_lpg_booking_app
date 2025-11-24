import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/supplier_controller/accept_order_controller.dart';
import 'package:lpg_booking_system/models/suppliers_models/getsupplier_order_response.dart';

class SupplierOrderDetailScreen extends StatefulWidget {
  final SupplierOrder order;
  final String supplierId;

  const SupplierOrderDetailScreen({
    super.key,
    required this.order,
    required this.supplierId,
  });

  @override
  State<SupplierOrderDetailScreen> createState() =>
      _SupplierOrderDetailScreenState();
}

class _SupplierOrderDetailScreenState extends State<SupplierOrderDetailScreen> {
  bool isLoading = false;

  /// Fixed cylinder prices
  double getCylinderPrice(String size) {
    switch (size) {
      case "11Kg":
      case "11kg":
        return 2780;
      case "15Kg":
      case "15kg":
        return 3720;
      case "45Kg":
      case "45kg":
        return 11160;
      default:
        return 0;
    }
  }

  Future<void> _acceptOrder() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await AcceptOrderSupplierController.acceptOrdersupplier(
        orderId: widget.order.orderId,
        supplierId: widget.supplierId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["Message"] ?? "Order accepted successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // go back to list after success
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> itemDetails =
        widget.order.items.map((item) {
          final price = getCylinderPrice(item.cylinderSize);
          final total = price * item.quantity;
          return {
            "size": item.cylinderSize,
            "quantity": item.quantity,
            "price": price,
            "total": total,
          };
        }).toList();

    final double grandTotal = itemDetails.fold(
      0,
      (sum, item) => sum + item["total"],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Supplier Order Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order Info
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ORDER ID: ${widget.order.orderId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("Vendor Name: ${widget.order.vendorName}"),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Vendor City",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(widget.order.vendorCity),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Phone",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(widget.order.vendorPhone),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("Status: ${widget.order.status}"),
                    Text("Order Date: ${widget.order.oDate}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Cylinder Table
            const Text(
              "Cylinder Detail",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(flex: 2, child: Text("Size Of Cylinder")),
                        Expanded(
                          child: Text("Quantity", textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text("Price", textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text("Total", textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                    const Divider(),
                    ...itemDetails.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(item["size"])),
                            Expanded(
                              child: Text(
                                "${item["quantity"]}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Rs. ${item["price"]}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Rs. ${item["total"]}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Grand Total: Rs. $grandTotal/-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Accept Order Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _acceptOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Accept Order",
                            style: TextStyle(
                              color: Colors.white,
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
