import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/cancel_order_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/current_orders_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/past_orders_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/repeat_order_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/scheduled_controller.dart';

import 'package:lpg_booking_system/models/customers_models/cancel_order_request.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/my_orders_response.dart';
import 'package:lpg_booking_system/models/customers_models/scheduled_request.dart';
import 'package:lpg_booking_system/models/customers_models/scheduled_response.dart';

import 'package:lpg_booking_system/views/screens/customer_screens/order_details.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/rating_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  final LoginResponse buyerId;
  const MyOrdersScreen({super.key, required this.buyerId});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedTab = 0;
  bool isLoading = true;
  List<CustomerOrders> currentOrders = [];
  List<CustomerOrders> pastOrders = [];

  final currentController = CustomerOrdersController();
  final pastController = CustomerPastOrdersController();
  final repeatController = RepeatOrderController();
  final scheduleController = ScheduleController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);

    try {
      final current = await currentController.fetchCurrentOrders(
        widget.buyerId.userid,
      );
      final past = await pastController.fetchPastOrders(widget.buyerId.userid);

      setState(() {
        currentOrders = current;
        pastOrders = past;
      });
    } catch (e) {
      print("Error loading orders: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabButton("CURRENT ORDER", 0),
                _tabButton("PAST ORDER", 1),
              ],
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                    : RefreshIndicator(
                      onRefresh: fetchOrders,
                      child:
                          selectedTab == 0
                              ? _buildOrderList(currentOrders, isPast: false)
                              : _buildOrderList(pastOrders, isPast: true),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<CustomerOrders> orders, {required bool isPast}) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders found",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, isPast: isPast);
      },
    );
  }

  Widget _buildOrderCard(CustomerOrders order, {required bool isPast}) {
    String cylinderList = order.items
        .map((item) => item.cylinderType)
        .toSet()
        .join(" + ");

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${order.orderId}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _statusChip(order.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Items (${order.items.length.toString().padLeft(2, '0')})",
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    cylinderList,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "RS ${order.price ?? 5000}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  isPast
                      ? [
                        _orderButton(
                          "VIEW ORDER",
                          Colors.orange,
                          Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CustomerOrderDetails(
                                      orderId: order.orderId,
                                      customer: widget.buyerId,
                                    ),
                              ),
                            );
                          },
                        ),
                        _orderButton(
                          "Want To Rate",
                          Colors.white,
                          Colors.orange,
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black38,
                              builder:
                                  (context) =>
                                      RatingScreen(orderId: order.orderId),
                            );
                          },
                        ),
                        _orderButton(
                          "Repeat Order",
                          Colors.white,
                          Colors.orange,
                          onPressed: () async {
                            await _handleRepeatOrder(order.orderId);
                          },
                        ),
                      ]
                      : [
                        _orderButton(
                          "CANCEL ORDER",
                          Colors.white,
                          Colors.red,
                          onPressed: () async {
                            final cancelController = CancelOrderController();

                            final result = await cancelController.cancelOrder(
                              CancelOrderRequest(orderId: order.orderId),
                            );

                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Order canceled successfully"),
                                ),
                              );
                              setState(() {
                                currentOrders.remove(order);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to cancel order"),
                                ),
                              );
                            }
                          },
                        ),
                        _orderButton(
                          "Scheduled",
                          Colors.white,
                          const Color.fromARGB(255, 22, 141, 26),
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                Duration(days: 1),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              helpText: "Select schedule date",
                            );

                            if (selectedDate != null) {
                              await _scheduleOrder(order.orderId, selectedDate);
                            }
                          },
                        ),
                      ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // 🔥 FIXED SCHEDULE METHOD
  // ---------------------------------------------------
  Future<void> _scheduleOrder(int orderId, DateTime selectedDate) async {
    try {
      // Create request
      final request = ScheduleOrderRequest(
        custId: widget.buyerId.userid, // Must include prefix e.g., "C-3506"
        orderId: orderId,
        scDate: selectedDate,
      );

      // API call
      final response = await scheduleController.scheduleOrder(request);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Order scheduled on ${selectedDate.toLocal().toString().split(' ')[0]}",
            ),
          ),
        );

        // ✅ Update status locally in the UI
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to schedule order: $e")));
    }
  }

  Future<void> _handleRepeatOrder(int orderId) async {
    final orderDetails = await repeatController.fetchOrderDetails(orderId);
    if (orderDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch order details")),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Repeat Order"),
            content: Text(
              "Are you sure you want to repeat order #$orderId from ${orderDetails.vendor.name}?",
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Yes, Repeat",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    final success = await repeatController.placeRepeatedOrder(orderId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order repeated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to repeat order")));
    }
  }

  Widget _statusChip(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'scheduled':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'dispatched':
        color = Colors.blue;
        icon = Icons.local_shipping;
        break;
      case 'delivered':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _orderButton(
    String title,
    Color bgColor,
    Color borderColor, {
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: borderColor,
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
