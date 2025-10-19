// views/screens/suppliers_screens/supplier_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/supplier_controller/supplier_order_controller.dart';
import 'package:lpg_booking_system/models/customers_models/vendororder_response.dart';
import 'package:lpg_booking_system/views/screens/suppliers_screens/show_order_details_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';

class SupplierOrdersScreen extends StatefulWidget {
  final String supplierId;
  const SupplierOrdersScreen({super.key, required this.supplierId});

  @override
  State<SupplierOrdersScreen> createState() => _SupplierOrdersScreenState();
}

class _SupplierOrdersScreenState extends State<SupplierOrdersScreen> {
  int selectedIndex = 0;
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = GetOrderService.getSupplierOrders(widget.supplierId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      appBar: AppBar(
        title: const Text(
          'Supplier Orders',
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
            return const Center(child: Text("No supplier orders found"));
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
            Text("Customer: ${order.buyerName}"),
            Text(order.buyerCity),
            Text("Status: ${order.status}"),
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
                          (context) => SupplierOrderDetailScreen(
                            order: order, // 👈 pass the selected order
                            supplierId: widget.supplierId,
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
