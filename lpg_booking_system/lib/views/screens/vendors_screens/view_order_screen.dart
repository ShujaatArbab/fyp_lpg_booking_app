import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controllers/accept_order_controller.dart';
import 'package:lpg_booking_system/models/vendororders_response.dart';
import 'package:lpg_booking_system/models/vendors_models/deliveryperson_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/deliverperson_screen.dart'; // 👈 add controller

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  final String vendorId;

  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.vendorId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String? dpName;
  String? dpPhone;
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
      final result = await AcceptOrderController.acceptOrder(
        orderId: widget.order.orderId,
        vendorId: widget.vendorId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["Message"] ?? "Order accepted successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Optionally go back after success
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: const Color.fromARGB(255, 70, 68, 68),
        ),
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
          "Order Details",
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
                    Text("Customer Id: ${widget.order.buyerName}"),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(widget.order.buyerCity),
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
                            Text(widget.order.buyerPhone),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Delivery Person Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Person",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Name: ${dpName ?? "__________"}"),
                    Text("Phone: ${dpPhone ?? "__________"}"),
                  ],
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                  ),
                  onPressed: () async {
                    final DeliveryPerson? selectedDp = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DeliveryPersonListScreen(
                              order: widget.order,
                              vendorId: widget.vendorId,
                            ),
                      ),
                    );

                    if (selectedDp != null) {
                      setState(() {
                        dpName = selectedDp.name;
                        dpPhone = selectedDp.phone;
                      });
                    }
                  },
                  child: const Text(
                    "Assign Person",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Cylinder Detail Table
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoading ? null : _acceptOrder,
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Accept Order",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
