import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/mothly_order_summary_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/monthly_order_response.dart';

class MonthlyOrderSummaryScreen extends StatefulWidget {
  final LoginResponse summary;

  const MonthlyOrderSummaryScreen({super.key, required this.summary});

  @override
  State<MonthlyOrderSummaryScreen> createState() =>
      _MonthlyOrderSummaryScreenState();
}

class _MonthlyOrderSummaryScreenState extends State<MonthlyOrderSummaryScreen> {
  late Future<VendorMonthlySummaryResponse> _summaryFuture;

  @override
  void initState() {
    super.initState();

    // ✅ USING LOGGED-IN VENDOR ID
    _summaryFuture = VendorReportService().getVendorMonthlySummary(
      widget.summary.userid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monthly Order Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<VendorMonthlySummaryResponse>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load summary",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _summaryCard(data),
                const SizedBox(height: 20),
                _cylinderSection(data.cylinderSummary),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔷 SUMMARY CARD
  Widget _summaryCard(VendorMonthlySummaryResponse data) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Month", data.month),
            _row("Total Orders", data.totalOrders.toString()),
            _row("Total Cylinders", data.totalCylinders.toString()),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 🔷 CYLINDER BREAKDOWN
  Widget _cylinderSection(List<CylinderSummary> cylinders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cylinder Breakdown",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...cylinders.map(
          (c) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.local_gas_station,
                color: Colors.orange,
              ),
              title: Text(
                c.cylinderSize,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "Qty: ${c.quantity}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
