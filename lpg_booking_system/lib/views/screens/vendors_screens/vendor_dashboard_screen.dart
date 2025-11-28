import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/vendor_dashboard_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/vendor_dashboard_response.dart';
import 'package:lpg_booking_system/views/screens/profile_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/show_supplier_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';

class VendorDashboardScreen extends StatefulWidget {
  final LoginResponse vendor; // pass vendor info

  const VendorDashboardScreen({super.key, required this.vendor});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  VendorDashboard? dashboard;
  bool loading = true;
  int selectedIndex = 0; // bottom nav selected index

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  void fetchDashboard() async {
    final data = await ApiService().getVendorDashboard(widget.vendor.userid);
    setState(() {
      dashboard = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dashboard == null) {
      return const Scaffold(body: Center(child: Text("No data found")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Vendor Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(), // HEADER
            buildStockCard(),
            buildCylinderInfo(),
            buildShopStockList(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });

          if (index == 0) {
            // Home tab, remain on the same screen
            return;
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Showsupplierscreen(vendor: widget.vendor),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersScreen(vendorId: widget.vendor),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(profile: widget.vendor),
              ),
            );
          }
        },
      ),
    );
  }

  // ------------------ HEADER ------------------
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.orange.shade400,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.vendor.name, // Vendor name
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "ID: ${widget.vendor.userid}", // Vendor ID
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ STOCK CARD ------------------
  Widget buildStockCard() {
    int pending = dashboard?.pendingOrders ?? 0;
    int dispatched = dashboard?.dispatchedOrders ?? 0;
    int delivered = dashboard?.deliveredOrders ?? 0;

    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Stock", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            "${dashboard?.totalStock ?? 0}",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      sections: [
                        PieChartSectionData(
                          color: Colors.orange,
                          value: pending.toDouble(),
                          radius: 40,
                          title: '',
                        ),
                        PieChartSectionData(
                          color: Colors.purple,
                          value: dispatched.toDouble(),
                          radius: 40,
                          title: '',
                        ),
                        PieChartSectionData(
                          color: Colors.blue,
                          value: delivered.toDouble(),
                          radius: 40,
                          title: '',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    legend("Pending", Colors.orange, pending),
                    legend("Dispatched", Colors.purple, dispatched),
                    legend("Delivered", Colors.blue, delivered),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget legend(String title, Color color, int value) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 5),
        Text("$title: $value"),
      ],
    );
  }

  // ------------------ CYLINDER INFO ------------------
  Widget buildCylinderInfo() {
    final allCylinders = <int, int>{};

    for (var shop in dashboard!.shopStocks) {
      for (var cylinder in shop.cylinderStocks) {
        allCylinders[cylinder.weight] =
            (allCylinders[cylinder.weight] ?? 0) + cylinder.quantity;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Cylinders Sold",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children:
                allCylinders.entries
                    .map((e) => chip("${e.key} KG: ${e.value} Sold"))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  // ------------------ SHOP STOCK LIST ------------------
  Widget buildShopStockList() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shop Stock Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...dashboard!.shopStocks.map((shop) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ExpansionTile(
                title: Text(shop.shopName),
                children:
                    shop.cylinderStocks.map((cylinder) {
                      return ListTile(
                        title: Text(cylinder.cylinderType),
                        trailing: Text("${cylinder.quantity} pcs"),
                      );
                    }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
