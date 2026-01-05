import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/estimated_consumption_controller.dart';
import 'package:lpg_booking_system/models/customers_models/estimate_consumption_response.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';

class LpgConsumptionScreen extends StatefulWidget {
  final LoginResponse consumption;
  const LpgConsumptionScreen({super.key, required this.consumption});

  @override
  State<LpgConsumptionScreen> createState() => _LpgConsumptionScreenState();
}

class _LpgConsumptionScreenState extends State<LpgConsumptionScreen> {
  List<ConsumptionResponse> lpgList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadlpgconsumption(); // fetch data when screen loads
  }

  void loadlpgconsumption() async {
    setState(() => isLoading = true);

    try {
      final response = await Consumption().fetchlpgconsumption(
        widget.consumption.userid,
      );
      setState(() {
        lpgList = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load LPG consumption")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LPG Consumptions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : lpgList.isEmpty
              ? Center(child: Text("No data found"))
              : ListView.builder(
                itemCount: lpgList.length,
                itemBuilder: (context, index) {
                  final item = lpgList[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Month: ${item.month}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Display each message
                          ...item.messages
                              .map((msg) => Text("• $msg"))
                              .toList(),
                          SizedBox(height: 4),
                          Text(
                            "Total: ${item.total} kg",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
