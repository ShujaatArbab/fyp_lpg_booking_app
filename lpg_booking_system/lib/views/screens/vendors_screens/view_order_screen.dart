import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/accept_order_controller.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/order_details_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/order_details_response.dart';
import 'package:lpg_booking_system/models/vendors_models/deliveryperson_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/deliverperson_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  final LoginResponse vendorId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.vendorId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailsResponse? orderDetails;
  String? dpName;
  String? dpPhone;
  bool isLoading = false;
  bool isFetching = true;

  final VendorOrderDetailsController _controller =
      VendorOrderDetailsController();

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    setState(() {
      isFetching = true;
    });

    final details = await _controller.fetchOrderDetails(widget.orderId);

    if (details != null && mounted) {
      setState(() {
        orderDetails = details;
        isFetching = false;
      });
    } else if (mounted) {
      setState(() {
        isFetching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to fetch order details"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Fixed cylinder prices
  double getCylinderPrice(String size) {
    switch (size.toLowerCase()) {
      case "11kg":
        return 2780;
      case "15kg":
        return 3720;
      case "45kg":
        return 11160;
      default:
        return 0;
    }
  }

  Future<void> _acceptOrder() async {
    if (orderDetails == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AcceptOrderController.acceptOrder(
        orderId: orderDetails!.orderId,
        vendorId: widget.vendorId.userid,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["Message"] ?? "Order accepted successfully"),
          backgroundColor: Colors.green,
        ),
      );

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
    if (isFetching) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (orderDetails == null) {
      return const Scaffold(
        body: Center(child: Text("No order details available")),
      );
    }

    final itemDetails =
        orderDetails!.items.map((item) {
          final price = getCylinderPrice(item.cylinderType);
          final total = price * item.quantity;
          return {
            "size": item.cylinderType,
            "quantity": item.quantity,
            "price": price,
            "total": total,
          };
        }).toList();

    final double grandTotal = itemDetails.fold(
      0.0,
      (sum, item) => sum + (item["total"] as num).toDouble(),
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
                      "ORDER ID: ${orderDetails!.orderId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("Customer Id: ${orderDetails!.buyer.id}"),
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
                            Text(orderDetails!.buyer.city),
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
                              vendorId: widget.vendorId.userid,
                              orderId: widget.orderId,
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
                            Expanded(
                              flex: 2,
                              child: Text(item["size"].toString()),
                            ),

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
