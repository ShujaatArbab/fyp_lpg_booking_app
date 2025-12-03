import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/current_order_controller.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/past_order_controller.dart';
import 'package:lpg_booking_system/models/vendors_models/currentorders_reponse.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/complaint_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/rating_screen.dart';

import 'package:lpg_booking_system/views/screens/vendors_screens/view_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  final LoginResponse vendorId;
  const OrdersScreen({super.key, required this.vendorId});

  @override
  State<OrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<OrdersScreen> {
  int selectedTab = 0; // 0 = current, 1 = past
  bool isLoading = true;

  List<VendorCurrentOrder> currentOrders = [];
  List<VendorCurrentOrder> pastOrders = [];

  final controller1 = VendorCurrentOrdersController();
  final controller2 = VendorPastOrdersController();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);

    try {
      final current = await controller1.getCurrentOrders(
        widget.vendorId.userid,
      );
      final past = await controller2.getPastOrders(widget.vendorId.userid);

      setState(() {
        currentOrders = current;
        pastOrders = past;
      });
    } catch (e) {
      print("Error loading vendor orders: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Vendor Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.orange,
            child: Row(
              children: [
                _tabButton("CURRENT ORDERS", 0),
                _tabButton("PAST ORDERS", 1),
              ],
            ),
          ),
          // Orders list
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

  Widget _buildOrderList(
    List<VendorCurrentOrder> orders, {
    required bool isPast,
  }) {
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
        return _buildOrderCard(orders[index], isPast: isPast);
      },
    );
  }

  Widget _buildOrderCard(VendorCurrentOrder order, {required bool isPast}) {
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
            // Order ID + Status
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
            Text("Customer: ${order.buyerName}"),
            Text(order.city),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    cylinderList,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Current Orders: View Order button
                if (!isPast)
                  _orderButton(
                    "VIEW ORDER",
                    Colors.orange,
                    Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => OrderDetailScreen(
                                orderId: order.orderId,
                                vendorId: widget.vendorId,
                              ),
                        ),
                      );
                    },
                  ),
                // Past Orders: Rate Order button
                if (isPast)
                  _orderButton(
                    "RATE ORDER",
                    Colors.white,
                    Colors.orange,

                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black38,
                        builder: (_) => RatingScreen(orderId: order.orderId),
                      );
                    },
                  ),
                const SizedBox(width: 8),
                // Past Orders: Complaint / Details button → CustomerOrderDetails
                if (isPast)
                  _orderButton(
                    "COMPLAINT",
                    Colors.orange,
                    Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ComplaintScreen(
                                orderid: order.orderId,
                                vendorname: order.sellerName,
                                customer: widget.vendorId,
                              ),
                        ),
                      );
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
      case 'pending':
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
            side: BorderSide(color: borderColor, width: 2),
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
