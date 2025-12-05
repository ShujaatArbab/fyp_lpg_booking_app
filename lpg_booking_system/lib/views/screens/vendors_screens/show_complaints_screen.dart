import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/get_complaint_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';

import 'package:lpg_booking_system/models/vendors_models/get_complaint_response.dart';

class ShowComplaintsScreen extends StatefulWidget {
  final LoginResponse vendorId; // vendorId passed from profile

  const ShowComplaintsScreen({super.key, required this.vendorId});

  @override
  State<ShowComplaintsScreen> createState() => _ShowComplaintsScreenState();
}

class _ShowComplaintsScreenState extends State<ShowComplaintsScreen> {
  late Future<List<GetComplaintResponse>> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = VendorComplaintService().getComplaintsByVendor(
      widget.vendorId.userid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendor Complaints',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<GetComplaintResponse>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No complaints
            return const Center(child: Text("No complaints found"));
          }

          // Complaints list
          final complaints = snapshot.data!;
          return ListView.builder(
            itemCount: complaints.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final c = complaints[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${c.orderId}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Buyer ID: ${c.buyerId}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Vendor Id: ${c.sellerId}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Complaint Text:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        c.complaintText,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 252, 17, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Complaint Status: ${c.complaintStatus}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Navigate to Solve Complaint Screen
                          print("Solve complaint ${c.comId}");
                        },
                        child: const Text(
                          "Solve",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
