import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/vendororders_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/vendororder_response.dart';
import 'package:lpg_booking_system/views/screens/profile_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/show_supplier_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/vendor_dashboard_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/view_order_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';

class OrdersScreen extends StatefulWidget {
  final LoginResponse vendorId;
  const OrdersScreen({super.key, required this.vendorId});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedIndex = 0;
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService.getVendorOrders(widget.vendorId.userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => VendorDashboardScreen(vendor: widget.vendorId),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Showsupplierscreen(vendor: widget.vendorId),
              ),
            );
          }
          if (index == 2) {
            return;
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(profile: widget.vendorId),
              ),
            );
          }
        },
      ),

      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  /// Simplified card UI (NO PRICE)
  Widget buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ORDER ID: ${order.orderId}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text("Customer Name: ${order.buyerName}"),
            Text(order.buyerCity), // show address
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.orange),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => OrderDetailScreen(
                            order: order,
                            vendorId: widget.vendorId.userid,
                          ),
                    ),
                  );
                },
                child: const Text(
                  "View Order",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
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
