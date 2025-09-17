import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendororders_controller.dart';
import 'package:lpg_booking_system/models/vendororders_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/deliverperson_screen.dart';

import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';

class Orders extends StatefulWidget {
  final String vendorId;
  const Orders({super.key, required this.vendorId});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int selectedIndex = 0;
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService.getVendorOrders("V-002"); // pass vendorId
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

  Widget buildOrderCard(Order order) {
    double grandTotal = 0;

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black12, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ORDER ID: ${order.orderId}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text("Customer Id: ${order.buyerName}"),
            const SizedBox(height: 12),
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
                        fontSize: 15,
                      ),
                    ),
                    Text(order.buyerCity),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Phone",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(order.buyerPhone),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Cylinder Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(flex: 2, child: Text("Size")),
                Expanded(child: Text("Quantity", textAlign: TextAlign.center)),
                Expanded(child: Text("Price", textAlign: TextAlign.center)),
                Expanded(child: Text("Total", textAlign: TextAlign.center)),
              ],
            ),
            const Divider(),
            ...order.items.map(
              (item) => Row(
                children: [
                  Expanded(flex: 2, child: Text(item.cylinderSize)),
                  Expanded(
                    child: Text(
                      "${item.quantity}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: Text("", textAlign: TextAlign.center)),
                  Expanded(child: Text("", textAlign: TextAlign.center)),
                ],
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Grand Total: $grandTotal",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Accept Order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 110,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.orange),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DeliveryPersonListScreen(
                                    order: order,
                                    vendorId: widget.vendorId,
                                  ),
                            ),
                          );
                        },
                        child: const Text(
                          "Assign person",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
