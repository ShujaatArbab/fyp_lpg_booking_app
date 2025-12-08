import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/see_schedule_order_controller.dart';
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/vendors_models/see_schedule_order.dart';

class SeeScheduledOrderScreen extends StatefulWidget {
  final String vendorId;
  const SeeScheduledOrderScreen({super.key, required this.vendorId});

  @override
  State<SeeScheduledOrderScreen> createState() =>
      _SeeScheduledOrderScreenState();
}

class _SeeScheduledOrderScreenState extends State<SeeScheduledOrderScreen> {
  late VendorScheduledController controller;
  List<VendorScheduledOrder> scheduledOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = VendorScheduledController(baseUrl: baseurl);
    _fetchScheduledOrders();
  }

  Future<void> _fetchScheduledOrders() async {
    setState(() => isLoading = true);

    try {
      final orders = await controller.fetchScheduledOrders(widget.vendorId);
      setState(() {
        scheduledOrders = orders;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch scheduled orders: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scheduled Orders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
              : RefreshIndicator(
                onRefresh: _fetchScheduledOrders,
                child:
                    scheduledOrders.isEmpty
                        ? const Center(child: Text("No scheduled orders found"))
                        : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: scheduledOrders.length,
                          itemBuilder: (context, index) {
                            final order = scheduledOrders[index];
                            final itemsSummary = order.items
                                .map(
                                  (i) => "${i.cylinderWeight}kg x${i.quantity}",
                                )
                                .join(" + ");

                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order #${order.orderId}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${order.scheduledDate.toLocal().toString().split(' ')[0]}",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Customer: ${order.customerName} (${order.customerId})",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Items: $itemsSummary",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
    );
  }
}
