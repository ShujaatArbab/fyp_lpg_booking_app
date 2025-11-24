import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/cancel_order_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/current_orders_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/past_orders_controller.dart';
import 'package:lpg_booking_system/models/customers_models/cancel_order_request.dart';
import 'package:lpg_booking_system/models/customers_models/my_orders_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/rating_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  final String buyerId;
  const MyOrdersScreen({super.key, required this.buyerId});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedTab = 0; // 0 = current, 1 = past
  bool isLoading = true;
  List<CustomerOrder> currentOrders = [];
  List<CustomerOrder> pastOrders = [];

  final currentController = CustomerOrdersController();
  final pastController = CustomerPastOrdersController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);

    try {
      final current = await currentController.fetchCurrentOrders(
        widget.buyerId,
      );
      final past = await pastController.fetchPastOrders(widget.buyerId);
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
          // 🔸 Tabs
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

          // 🔹 Orders list
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

  Widget _buildOrderList(List<CustomerOrder> orders, {required bool isPast}) {
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

  Widget _buildOrderCard(CustomerOrder order, {required bool isPast}) {
    String cylinderList = order.items
        .map((item) => item.cylinderType)
        .toSet()
        .join(" + "); // unique cylinder types

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Order ID + Status
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
                            // VIEW ORDER action (currently do nothing)
                          },
                        ),
                        _orderButton(
                          "Want To Rate",
                          Colors.white,
                          Colors.orange,
                          onPressed: () {
                            // Navigate to the rating screen
                            showDialog(
                              context: context,
                              barrierColor:
                                  Colors.black38, // semi-transparent background
                              builder:
                                  (context) =>
                                      RatingScreen(orderId: order.orderId),
                            );
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
                                SnackBar(
                                  content: Text("Order canceled successfully"),
                                ),
                              );

                              // Remove from list instantly without refresh
                              setState(() {
                                currentOrders.remove(order);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to cancel order"),
                                ),
                              );
                            }
                          },
                        ),
                        _orderButton(
                          "TRACK ORDER",
                          Colors.white,
                          Colors.green,
                          onPressed: () {
                            // TRACK ORDER action (currently do nothing)
                          },
                        ),
                      ],
            ),
          ],
        ),
      ),
    );
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
          onPressed: onPressed, // <-- FIXED
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
