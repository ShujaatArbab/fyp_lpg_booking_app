import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/supplier_controller/accept_order_controller.dart';

import 'package:lpg_booking_system/controllers/customer_controller/cancel_order_controller.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/order_details_controller.dart';
import 'package:lpg_booking_system/models/customers_models/cancel_order_request.dart';

import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/order_details_response.dart';
import 'package:lpg_booking_system/models/vendors_models/deliveryperson_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/deliverperson_screen.dart';

class SupplierOrderDetailScreen extends StatefulWidget {
  final int orderId;
  final String supplierId;

  const SupplierOrderDetailScreen({
    super.key,
    required this.orderId,
    required this.supplierId,
  });

  @override
  State<SupplierOrderDetailScreen> createState() =>
      _SupplierOrderDetailScreenState();
}

class _SupplierOrderDetailScreenState extends State<SupplierOrderDetailScreen> {
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

  Future<void> _acceptOrder() async {
    if (orderDetails == null) return;

    if (dpName == null || dpName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please assign a delivery person before accepting"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AcceptOrderSupplierController.acceptOrdersupplier(
        orderId: orderDetails!.orderId,
        supplierId: widget.supplierId,
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

  Future<void> _rejectOrder() async {
    if (orderDetails == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final request = CancelOrderRequest(orderId: orderDetails!.orderId);
      final response = await CancelOrderController().cancelOrder(request);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to cancel order"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
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
    if (isFetching) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (orderDetails == null) {
      return const Scaffold(
        body: Center(child: Text("No order details available")),
      );
    }

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
            /// Order Info Card
            Container(
              width: 400,
              child: Card(
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
                      Text("Buyer: ${orderDetails!.buyer.name}"),
                      const SizedBox(height: 6),
                      Text("Buyer City: ${orderDetails!.buyer.city}"),
                      const SizedBox(height: 6),
                      Text("Status: ${orderDetails!.status}"),
                      const SizedBox(height: 6),
                      Text(
                        "Order Date: ${orderDetails!.orderDate.toString().split(' ')[0]}",
                      ),
                    ],
                  ),
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
                              vendorId: widget.supplierId,
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

            /// Cylinder Detail Card
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
                      ],
                    ),
                    const Divider(),
                    ...orderDetails!.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(item.cylinderType)),
                            Expanded(
                              child: Text(
                                "${item.quantity}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Rs. ${item.price}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Accept  Button
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

            const SizedBox(height: 12),

            /// Reject Order Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _rejectOrder,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Reject Order",
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
